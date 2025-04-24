import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fit_bro/models/data/data.dart';
import 'package:share_plus/share_plus.dart'; // <- For sharing
import '../../common/color_extension.dart';

class WorkoutDetailView extends StatefulWidget {
  final Exercise exercise;
  const WorkoutDetailView({super.key, required this.exercise});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  bool isLiked = false;

  final List<Map<String, String>> responseArr = [
    {
      "name": "Wafaa Samir",
      "time": "09 days ago",
      "image": "assets/img/u2.png",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
    },
    {
      "name": "Ahmed Mohab",
      "time": "11 days ago",
      "image": "assets/img/u1.png",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
    },
    {
      "name": "Sara Ali",
      "time": "12 days ago",
      "image": "assets/img/u2.png",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
    },
    {
      "name": "Mikhail Eduardovich",
      "time": "13 days ago",
      "image": "assets/img/u1.png",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            "assets/img/black_white.png",
            width: 25,
            height: 25,
          ),
        ),
        title: Text(
          overflow: TextOverflow.ellipsis,
          widget.exercise.name,
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.exercise.image,
              width: media.width,
              height: media.width * 0.55,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder:
                        (context, _) => Icon(Icons.star, color: TColor.primary),
                    onRatingUpdate: (rating) {},
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        '${widget.exercise.name}\n\nCheck this out: ${widget.exercise.image}\n\nInstructions: ${widget.exercise.instruction}',
                        subject: 'Workout: ${widget.exercise.name}',
                      );
                    },
                    icon: Icon(Icons.share, color: Colors.blueGrey, size: 24),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instructions",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.exercise.instruction,
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
