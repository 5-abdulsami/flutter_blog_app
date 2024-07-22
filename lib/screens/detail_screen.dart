import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  String title, description, image;
  DetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.image});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
                placeholder: 'assets/images/blog_logo.png',
                image: widget.image,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const Divider(
              thickness: 1,
            ),
            Text(
              widget.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.25, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
