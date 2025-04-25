import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart'; // <- For sharing
import '../../common/color_extension.dart';

class YogaView extends StatefulWidget {
  const YogaView({super.key});

  @override
  State<YogaView> createState() => _YogaViewState();
}

class _YogaViewState extends State<YogaView> {
  final List<Map<String, String>> workArr = [
    {"name": "Jumping", "image": "assets/img/2.png"},
    {"name": "Stretch", "image": "assets/img/3.png"},
  ];



  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          "Yoga",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/img/1.png",
                width: media.width,
                height: media.width * 0.55,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 24,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder:
                        (context, _) => Icon(Icons.star, color: TColor.primary),
                    onRatingUpdate: (_) {},
                  ),
                ),
                const Spacer(),

                IconButton(
                  onPressed: () {
                    Share.share(
                      'Check out this amazing Yoga exercise!\n\n${workArr[0]['name']}',
                      subject: 'Yoga Exercise: ${workArr[0]['name']}',
                    );
                  },
                  icon: Icon(Icons.share, color: Colors.blueGrey, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Tips",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TColor.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                "Yoga is more than just a physical practice—it’s a journey of the mind, body, and breath. "
                "By connecting movement with mindful breathing, yoga helps reduce stress, improve flexibility, and increase overall mental clarity.\n\n"
                "Beginner Tips:\n"
                "- Start with basic poses like Child’s Pose, Downward Dog, and Mountain Pose.\n"
                "- Don’t worry about being perfect—listen to your body.\n"
                "- Focus on your breathing—it’s your guide.\n\n"
                "Benefits:\n"
                "- Enhances strength and flexibility\n"
                "- Improves posture and balance\n"
                "- Promotes better sleep and mental focus\n\n"
                "Yoga isn’t about touching your toes—it’s about what you learn on the way down. "
                "Take your time, stay consistent, and enjoy every moment on the mat.",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: TColor.secondaryText,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
