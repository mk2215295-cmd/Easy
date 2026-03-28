import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esy/screens/login_screen.dart';
import 'package:esy/screens/dashboard_screen.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('EASY WORK AI'), findsOneWidget);
  });

  testWidgets('Dashboard shows bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('رادار الوظائف'), findsOneWidget);
    expect(find.text('الإشعارات'), findsOneWidget);
    expect(find.text('الملف'), findsOneWidget);
  });
}
