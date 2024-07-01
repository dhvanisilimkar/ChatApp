import 'package:fb_chat_app/helper/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../helper/firestore_helper.dart';
import '../../modal/user_modal.dart';
import '../../utils/colors.dart';
import '../../utils/current_utils.dart';
import '../../utils/routes.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    RxBool passCkeck = false.obs;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(60),
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                ),
                const Gap(10),
                Text(
                  "Hi! Wlcome back, You've been missed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Gap(60),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: darkBlue,
                        ),
                      ),
                      fillColor: greyTheme,
                    ),
                    validator: (val) {
                      return (val == "") ? "Enter Email" : null;
                    },
                    onChanged: (val) {},
                  ),
                ),
                const Gap(15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Obx(
                    () => TextFormField(
                      controller: passwordController,
                      validator: (val) {
                        return (val == "") ? "Enter password" : null;
                      },
                      obscureText: passCkeck.value,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: darkBlue,
                          ),
                        ),
                        fillColor: greyTheme,
                        suffixIcon: IconButton(
                          onPressed: () {
                            passCkeck(!passCkeck.value);
                          },
                          icon: Obx(
                            () => (passCkeck.value)
                                ? const Icon(Icons.visibility)
                                : const Icon(
                                    Icons.visibility_off,
                                  ),
                          ),
                        ),
                      ),
                      onChanged: (val) {},
                    ),
                  ),
                ),
                const Gap(10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: darkBlue,
                        color: darkBlue,
                      ),
                    ),
                  ),
                ),
                const Gap(40),
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: darkBlue,
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        User? user = await AuthHepler.authHepler.userSignUp(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );
                        if (user != null) {
                          UserModal userModal = await FireStoreHelper
                              .fireStoreHelper
                              .getUserByEmail(email: user.email as String);
                          CurrentUser.user = userModal;

                          Navigator.of(context)
                              .pushReplacementNamed(MyRoutes.home);
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    splashColor: Colors.white,
                    child: Container(
                      height: 50,
                      width: s.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          color: colors,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(40),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Or sign In with",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    const Gap(15),
                    Ink(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () async {
                          User? user =
                              await AuthHepler.authHepler.SignInWithGoogle();
                          if (user != null) {
                            FireStoreHelper.fireStoreHelper
                                .setUserData(users: user)
                                .then(
                              (value) async {
                                UserModal userModal = await FireStoreHelper
                                    .fireStoreHelper
                                    .getUserByEmail(
                                        email: user.email as String);
                                CurrentUser.user = userModal;
                                return Navigator.of(context)
                                    .pushReplacementNamed(MyRoutes.home);
                              },
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(200),
                        splashColor: Colors.grey,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/logo/google.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Spacer(),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(fontSize: 16, color: darkBlue),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.create);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: darkBlue,
                          color: colors,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
