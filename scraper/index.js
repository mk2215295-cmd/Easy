import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import fetch from 'node-fetch';
import { translate } from '@vitalets/google-translate-api';

// Use service account from env for GitHub Actions
const serviceAccountKeyStr = process.env.FIREBASE_SERVICE_ACCOUNT_KEY;
if (!serviceAccountKeyStr) {
  console.error("Missing FIREBASE_SERVICE_ACCOUNT_KEY environment variable.");
  process.exit(1);
}

const serviceAccount = JSON.parse(serviceAccountKeyStr);

initializeApp({
  credential: cert(serviceAccount)
});

const db = getFirestore();

// Helper to clean HTML
function stripHtml(html) {
  return html
    .replace(/<br\s*\/?>/gi, '\n')
    .replace(/<\/p>/gi, '\n\n')
    .replace(/<\/li>/gi, '\n')
    .replace(/<\/h2>/gi, '\n\n')
    .replace(/<\/h3>/gi, '\n\n')
    .replace(/<[^>]*>/g, '')
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&#x26;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&#039;/g, "'")
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

async function fetchArbeitnow() {
  const res = await fetch('https://www.arbeitnow.com/api/job-board-api');
  if (!res.ok) throw new Error(`Arbeitnow failed: ${res.statusText}`);
  const data = await res.json();
  return data.data || [];
}

async function fetchJobicy() {
  const res = await fetch('https://jobicy.com/api/v2/remote-jobs?count=20');
  if (!res.ok) throw new Error(`Jobicy failed: ${res.statusText}`);
  const data = await res.json();
  return data.jobs || [];
}

async function translateText(text, retries = 3) {
  if (!text || text.trim() === '') return '';
  for (let i = 0; i < retries; i++) {
    try {
      const res = await translate(text, { to: 'ar' });
      return res.text;
    } catch (e) {
      console.warn(`Translation retry ${i+1}/${retries} failed:`, e.message);
      await new Promise(r => setTimeout(r, 1500));
    }
  }
  return text; // fallback to original
}

async function extractRequirementsFromText(text, jobIdPrefix) {
  const lines = text
    .split('\n')
    .map(l => l.replace(/^[•\-\*\d\.]+\s*/, '').trim())
    .filter(l => l.length > 8);

  const reqs = [];
  let id = 1;

  for (const line of lines) {
    const lower = line.toLowerCase();
    if (
      lower.includes('experience') || lower.includes('degree') ||
      lower.includes('ability') || lower.includes('knowledge') ||
      lower.includes('skills') || lower.includes('proficient') ||
      lower.includes('studium') || lower.includes('erfahrung') ||
      lower.includes('kenntnisse') || lower.includes('years') ||
      lower.includes('verantwortung') || lower.includes('qualifikation')
    ) {
      reqs.push({
        id: `${jobIdPrefix}-req-${id}`,
        text_en: line,
        text_ar: await translateText(line)
      });
      id++;
      if (reqs.length >= 6) break;
    }
  }

  if (reqs.length === 0) {
    for (let i = 0; i < lines.length && reqs.length < 4; i++) {
      reqs.push({
        id: `${jobIdPrefix}-req-${id}`,
        text_en: lines[i],
        text_ar: await translateText(lines[i])
      });
      id++;
    }
  }
  return reqs;
}

function extractBenefitsFromText(text) {
  const lower = text.toLowerCase();
  const benefits = [];

  if (lower.includes('housing') || lower.includes('relocation') || lower.includes('apartment') || lower.includes('sorglos-zuhause')) {
    benefits.push({
      id: 'ben-house',
      type: 'accommodation',
      label_ar: 'توفير وتسهيل السكن والتنقل',
      label_en: 'Housing & Relocation Support'
    });
  }
  if (lower.includes('health') || lower.includes('insurance') || lower.includes('krankenversicherung')) {
    benefits.push({
      id: 'ben-health',
      type: 'healthInsurance',
      label_ar: 'تأمين صحي شامل',
      label_en: 'Full Health & Medical Insurance'
    });
  }
  if (lower.includes('bonus') || lower.includes('salary') || lower.includes('compensation') || lower.includes('performance')) {
    benefits.push({
      id: 'ben-bonus',
      type: 'bonus',
      label_ar: 'مكافآت وحوافز أداء دورية',
      label_en: 'Performance Bonus & Incentives'
    });
  }
  if (lower.includes('flight') || lower.includes('ticket') || lower.includes('travel') || lower.includes('home')) {
    benefits.push({
      id: 'ben-flight',
      type: 'flightTicket',
      label_ar: 'تذاكر طيران ودعم السفر الدولي',
      label_en: 'Annual Flight & Travel Allowance'
    });
  }
  if (benefits.length === 0) {
    benefits.push(
      {
        id: 'ben-std-1',
        type: 'healthInsurance',
        label_ar: 'تأمين صحي وبيئة عمل مرنة',
        label_en: 'Health Insurance & Flexible Work'
      },
      {
        id: 'ben-std-2',
        type: 'visa',
        label_ar: 'دعم التأشيرة والإقامة الرسمية',
        label_en: 'Visa & Work Permit Sponsorship'
      }
    );
  }
  return benefits;
}

async function processJob(id, title, company, loc, desc, applyUrl, isRemote, jobType, salaryMin, salaryMax, salaryCurrency) {
  const cleanDesc = stripHtml(desc);
  
  console.log(`Processing: ${id} - ${title}`);
  
  // Clean translation of title, loc, description
  const titleAr = await translateText(title);
  const locAr = await translateText(loc);
  
  // Truncate desc for fast translation (we just need a short description for UI usually)
  const shortText = cleanDesc.length > 500 ? cleanDesc.substring(0, 500) + '...' : cleanDesc;
  const descAr = await translateText(shortText);

  // Classify as Volunteer if keywords present
  const tLower = title.toLowerCase();
  const dLower = cleanDesc.toLowerCase();
  let category = isRemote ? 'Global Remote' : 'European Market';
  
  if (tLower.includes('volunteer') || tLower.includes('freiwilliger') || dLower.includes('volunteer')) {
    category = 'Volunteering';
  }

  const reqs = await extractRequirementsFromText(cleanDesc, id);
  const bens = extractBenefitsFromText(cleanDesc);

  // Create Job object
  return {
    id: id,
    title: title,
    title_ar: titleAr,
    company: company,
    location: loc,
    location_ar: locAr,
    description: cleanDesc,
    description_ar: descAr,
    salary_min: salaryMin,
    salary_max: salaryMax,
    salary_currency: salaryCurrency,
    salary_period: 'month',
    hero_image_url: 'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&q=80&w=600',
    category: category,
    job_type: jobType,
    apply_url: applyUrl,
    requirements: reqs,
    benefits: bens,
    posted_at: new Date().toISOString(),
    is_new: true,
    is_featured: true,
    is_active: true
  };
}

async function run() {
  console.log('Starting scheduled scraper...');
  
  let liveJobs = [];
  
  // Arbeitnow
  try {
    const arbeitData = await fetchArbeitnow();
    let idx = 1;
    for (const item of arbeitData.slice(0, 15)) {
      const id = `arbeitnow-live-${idx}`;
      const job = await processJob(
        id, 
        item.title || 'European Opportunity', 
        item.company_name || 'European Employer', 
        item.location || 'Frankfurt, Germany',
        item.description || '',
        item.url || 'https://www.arbeitnow.com',
        item.remote || false,
        item.remote ? 'Remote' : 'Full-Time',
        2800 + (idx * 120),
        3800 + (idx * 180),
        '€'
      );
      liveJobs.push(job);
      idx++;
    }
  } catch (e) {
    console.error('Error fetching Arbeitnow', e);
  }

  // Jobicy
  try {
    const jobicyData = await fetchJobicy();
    let idx = 1;
    for (const item of jobicyData.slice(0, 15)) {
      const id = `jobicy-live-${idx}`;
      const sMin = parseFloat(item.salaryMin) || 3200;
      const sMax = parseFloat(item.salaryMax) || 4500;
      const sCurr = item.salaryCurrency || '€';
      
      const job = await processJob(
        id,
        item.jobTitle || 'Remote Role',
        item.companyName || 'Global Employer',
        item.jobGeo || 'Europe',
        item.jobDescription || '',
        item.url || 'https://jobicy.com',
        true,
        'Remote',
        sMin > 10000 ? sMin / 12 : sMin,
        sMax > 10000 ? sMax / 12 : sMax,
        sCurr === 'USD' ? '$' : (sCurr === 'GBP' ? '£' : '€')
      );
      liveJobs.push(job);
      idx++;
    }
  } catch (e) {
    console.error('Error fetching Jobicy', e);
  }

  console.log(`Scraped ${liveJobs.length} live jobs.`);

  const batch = db.batch();
  const jobsRef = db.collection('jobs');

  // Fetch existing
  const existingSnapshot = await jobsRef.get();
  const existingIds = new Set();
  existingSnapshot.forEach(doc => {
    existingIds.add(doc.id);
  });

  const scrapedIds = new Set();
  
  // Upsert scraped jobs
  for (const job of liveJobs) {
    const docRef = jobsRef.doc(job.id);
    batch.set(docRef, job, { merge: true });
    scrapedIds.add(job.id);
  }

  // Delete/Mark inactive jobs not in scraped data
  for (const id of existingIds) {
    if (!scrapedIds.has(id)) {
      console.log(`Deleting expired job: ${id}`);
      batch.delete(jobsRef.doc(id));
    }
  }

  await batch.commit();
  console.log('Cleanup and Sync completed successfully!');
}

run().catch(console.error);
