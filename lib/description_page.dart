import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final String name, description, bannerurl, posterurl, vote, launch_on;

  const Description(
      {Key? key,
      required this.name,
      required this.description,
      required this.bannerurl,
      required this.posterurl,
      required this.vote,
      required this.launch_on})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            bannerurl,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 15),
        Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
        Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Release Date -$launch_on        Rating - $vote/10",
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
        Row(
          children: [
            Container(
              height: 200,
              width: 100,
              child: Image.network(posterurl),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          ],
        )
      ]),
    );
  }
}
