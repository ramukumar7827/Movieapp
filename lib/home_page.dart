import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/login_page.dart';
import 'package:movie_app/movies.dart';
import 'package:movie_app/search_page.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingmovies = [];
  List topratedmovies = [];
  List nowplay = [];

  final String apikey = '3376a18a481faea92be0a6cd7c14d413';
  final readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMzc2YTE4YTQ4MWZhZWE5MmJlMGE2Y2Q3YzE0ZDQxMyIsInN1YiI6IjYzYTU4YmIzMzg3NjUxMDBkMTg3NmU5MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-qvd-9qRqs_GFrfOju2DYc903MJTCAnUEJNLFDGGPPw';

  @override
  void initState() {
    loadmovies();
    super.initState();
  }

  List searcher = [];
  fetchresult(String reqmv) async {
    var url;
    url = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/search/movie?api_key=3376a18a481faea92be0a6cd7c14d413&language=en-US&query=$reqmv&page=1&include_adult=false)"));
    setState(() {
      searcher = json.decode(url.body)['results'];
    });
  }

  loadmovies() async {
    TMDB tmdbLogs = TMDB(ApiKeys(apikey, readaccesstoken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map trendingresult = await tmdbLogs.v3.trending.getTrending();
    Map topratedresult = await tmdbLogs.v3.movies.getTopRated();
    Map nowresult = await tmdbLogs.v3.movies.getNowPlaying();
    setState(() {
      trendingmovies = trendingresult['results'];
      topratedmovies = topratedresult['results'];
      nowplay = nowresult['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchbar = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVIE APP',
            style: GoogleFonts.montserrat(
                fontSize: 30, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                });
              },
              child: const Text("SIGN OUT"))
              
        ],
        
      ),
      body: Container(
        width: w,
        height: h,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
           TextField(
              controller: _searchbar,
              style:
                  const TextStyle(color: Colors.black), // Text inside the field
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.movie_filter_outlined,
                    color: Colors.black),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () async {
                    await fetchresult(_searchbar.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchRes(searcher: searcher),
                      ),
                    );
                  },
                ),
                labelText: "Enter the Movie",
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.white, // White background
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(style: BorderStyle.none),
                ),
              ),
            ),

            TrendingMovies(trending: trendingmovies),
            TopMovies(topmovie: topratedmovies),
            NowPlay(nowplaymv: nowplay),
          ],
        ),
      ),
    );
  }
}
