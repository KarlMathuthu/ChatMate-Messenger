import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:status_view/status_view.dart';

class StatusesPage extends StatefulWidget {
  const StatusesPage({super.key});

  @override
  State<StatusesPage> createState() => _StatusesPageState();
}

class _StatusesPageState extends State<StatusesPage> {
  List<String> names = [
    "@AlexAmbrose",
    "@DebbieClifton",
    "@JustinAmbrose",
  ];
  List<int> numberOfStatus = [
    3,
    1,
    5,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Text(
                    names[index],
                    style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "Today at 15:04",
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  leading: StatusView(
                    radius: 25,
                    spacing: 15,
                    strokeWidth: 2,
                    indexOfSeenStatus: 1,
                    numberOfStatus: numberOfStatus[index],
                    padding: 4,
                    centerImageUrl: "https://picsum.photos/200/300",
                    seenColor: Colors.grey,
                    unSeenColor: Colors.red,
                  ),
                );
              },
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
