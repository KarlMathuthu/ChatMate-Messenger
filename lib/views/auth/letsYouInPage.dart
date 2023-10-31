import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/constants.dart';
import 'package:chat_mate_messanger/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LetsYouInPage extends StatelessWidget {
  const LetsYouInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(backgroundColor: AppTheme.scaffoldBacgroundColor),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                Images.splashImage2,
                height: 160,
                width: 160,
              ),
            ),
          ),
          Text(
            AppConstants.introText,
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(child: SizedBox()),
          //Google login button.
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.facebook,
                  color: AppTheme.mainColor,
                ),
                const SizedBox(width: 10),
                Text(
                  "Continue with Facebook",
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "Or",
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //Signin with email
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.mainColor,
                child: Text(
                  "Signin with email",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.toNamed(RouteClass.loginPage);
                },
              ),
            ),
          ),

          const SizedBox(height: 10),
          //Don't have an accoutn yet?, Signup.
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteClass.createAccountPage);
            },
            child: Container(
              height: 30,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Sign up",
                        style: GoogleFonts.lato(
                          color: AppTheme.mainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
