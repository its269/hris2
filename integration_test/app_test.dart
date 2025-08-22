import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hris/pages_admin/login_page.dart';
import 'package:hris/theme_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Verify color scheme consistency', (WidgetTester tester) async {
    // Build the LoginPage widget with ThemeProvider
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeProvider().currentTheme,
        home: const LoginPage(),
      ),
    );

    // Verify LoginPage is displayed
    expect(find.text('Welcome to HRIS!'), findsOneWidget);

    // Verify color scheme is applied
    final backgroundColor = (tester.firstWidget(find.byType(Scaffold)) as Scaffold).backgroundColor;
    expect(backgroundColor, ThemeProvider().currentTheme.scaffoldBackgroundColor);
  });
}
