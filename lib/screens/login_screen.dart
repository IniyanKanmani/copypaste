import 'package:copypaste/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    if (mobileAndWeb.contains(device)) {
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
    if (mobileAndWeb.contains(device)) {
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
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(fontSize: 17),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: signIn,
                      child: const Center(
                        child: Text(
                          "    Login    ",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: signUp,
                      child: const Center(
                        child: Text(
                          "   Sign Up   ",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
