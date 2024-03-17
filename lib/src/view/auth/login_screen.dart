import 'package:firebase_project/src/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isHintPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 200,
            ),
            TextFielWidget(
              prefixIcon: Icons.email,
              hintText: 'Enter E-mail',
            ),
            TextFielWidget(
              prefixIcon: Icons.lock_open_rounded,
              hintText: 'Enter password',
              hintPassword: isHintPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHintPassword = !isHintPassword;
                    });
                  },
                  icon: Icon(isHintPassword
                      ? Icons.visibility
                      : Icons.visibility_off)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                  color: Colors.blueAccent,
                  child: const Text('Sign In'),
                  onPressed: () {}),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'If you have account!.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: Text("Create account"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
