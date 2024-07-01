import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/colors.dart';
import '../../utils/routes.dart';

class LetsPage extends StatelessWidget {
  const LetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo/logo4.png', scale: 2.5),
                    Gap(05),
                    Text(
                      "Talk Hub",
                      style: TextStyle(
                          fontSize: 30,
                          color: darkBlue,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const Gap(20),
                Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    'assets/images/intro.jpg',
                  ),
                ),
                const Gap(50),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Your Premier ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colors,
                      ),
                    ),
                    Text(
                      "Social",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: darkBlue),
                    ),
                    Spacer(),
                  ],
                ),
                Text(
                  "Connection App",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkBlue),
                ),
                const Gap(20),
                const Text(
                  " It's a digital technology that enables people to shareprefernces ideas and information through virtual networks.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const Gap(20),
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: darkBlue,
                  ),
                  child: InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, MyRoutes.create);
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
                        "Let's Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: colors,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Already have an Account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: darkBlue,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.sign);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: colors,
                          color: colors,
                        ),
                      ),
                    ),
                    Spacer(),
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
