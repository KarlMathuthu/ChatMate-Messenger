import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusesPage extends StatefulWidget {
  const StatusesPage({super.key});

  @override
  State<StatusesPage> createState() => _StatusesPageState();
}

class _StatusesPageState extends State<StatusesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            //My Status.
            ListTile(
              onTap: () {},
              title: Text(
                "My Status",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Tap to add status updates",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              leading: Stack(
                children: [
                  // CircleAvatar
                  const CircleAvatar(
                    //    radius: 25,
                    backgroundColor: Color.fromARGB(255, 222, 235, 255),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.mainColor,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Recent Statuses.
            /*  Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  "Recent Statuses",
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ), */
            //Viewed statuses.
            /*  Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  "Viewed Statuses",
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ), */
          ],
        ),
      ),
    );
  }
}
