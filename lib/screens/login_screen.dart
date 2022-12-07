import 'package:flutter/material.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:firebase_for_all/firebase_for_all.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuthForAll.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future signUp() async {
    await FirebaseAuthForAll.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: loginTextField(
                  controller: emailController,
                  action: TextInputAction.next,
                  inputType: TextInputType.emailAddress,
                  hintText: "Email",
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: loginTextField(
                  controller: passwordController,
                  action: TextInputAction.done,
                  inputType: TextInputType.text,
                  hintText: "Password",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      loginElevatedButton(
                        onTap: signIn,
                        text: "Login",
                      ),
                      loginElevatedButton(
                        onTap: signUp,
                        text: "Sign Up",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 75.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
