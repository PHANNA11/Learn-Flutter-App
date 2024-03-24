import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/src/view/home/home_screen.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 200,
            ),
            TextFielWidget(
              controller: emailController,
              prefixIcon: Icons.email,
              hintText: 'Enter E-mail',
            ),
            TextFielWidget(
              controller: passwordController,
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
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (credential.user!.getIdToken() != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }
                    } on FirebaseAuthException catch (e) {
                      log(e.credential!.providerId);
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }),
            ),
            // TODO : Login with google and Facebook
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.facebook,
                        size: 40,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.language,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'If you have account!.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text("Create account"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
