import 'package:flutter/material.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe to Motive8ai',
            style: themeData.textTheme.titleLarge),
        backgroundColor: themeData.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Unlock all premium features',
              style: themeData.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Get access to all premium features and maximize your productivity.',
              style: themeData.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Start a 1-week free trial, then just \$10/month.',
              style: themeData.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(themeData.primaryColor),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Text(
                  'Start Free Trial',
                  style: themeData.textTheme.labelLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                'Restore Purchases',
                style: themeData.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
