import 'package:copypaste/constants/constants.dart';
import 'package:copypaste/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    if (mobile.contains(device) || web.contains(device)) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return;
    }
    // else {
    //   await firedart.FirebaseAuth.instance.signIn(
    //     emailController.text.trim(),
    //     passwordController.text.trim(),
    //   );
    //   saveToSharedPreferences(
    //     email: emailController.text.trim(),
    //     password: passwordController.text.trim(),
    //   );
    // }
  }

  Future signUp() async {
    if (mobile.contains(device) || web.contains(device)) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // await ClipboardManager.sendDataToCloud(
      //     newData: "Hello", device: device!, deviceName: deviceName!);
      return;
    }
    // else {
    //   await firedart.FirebaseAuth.instance.signUp(
    //     emailController.text.trim(),
    //     passwordController.text.trim(),
    //   );
    //   saveToSharedPreferences(
    //     email: emailController.text.trim(),
    //     password: passwordController.text.trim(),
    //   );
    // }
  }

  // void saveToSharedPreferences(
  //     {required String email, required String password}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   await prefs.setString("email", email);
  //   await prefs.setString("password", password);
  //   await prefs.setBool("loggedIn", true);
  // }

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
