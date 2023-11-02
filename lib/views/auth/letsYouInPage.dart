import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/constants.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          Text(
            AppConstants.introText,
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          Text(
            "Join other mates today!",
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
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
                SvgPicture.asset(
                  CustomIcons.googleIcon,
                  height: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  "Continue with Google",
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
                  "Login with email",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
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
