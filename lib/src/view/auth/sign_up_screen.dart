import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/src/view/home/home_screen.dart';
import 'package:firebase_project/src/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool isHintPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: SafeArea(
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
                TextFielWidget(
                  controller: cpasswordController,
                  prefixIcon: Icons.lock_open_rounded,
                  hintText: 'Enter c-password',
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
                      child: const Text('Create'),
                      onPressed: () async {
                        if (passwordController.text ==
                                cpasswordController.text &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            cpasswordController.text.isNotEmpty) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            if (credential != null) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      }),
                ),
                // TODO : Login with google and Facebook

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'If you have account!.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () async {},
                        child: const Text("Back to Login"))
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
