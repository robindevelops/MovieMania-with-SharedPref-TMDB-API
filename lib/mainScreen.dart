// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:movie_mania/moviesModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_api/tmdb_api.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  late Future<void> _fetchMovies;

  @override
  void initState() {
    super.initState();
    _fetchMovies = getmovies();
  }

  List<Movie> movies = [];
  Future<void> getmovies() async {
    String apikey = 'b8a21d188822d34a82b13f9fac6f96c8';
    String accesstoken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGEyMWQxODg4MjJkMzRhODJiMTNmOWZhYzZmOTZjOCIsInN1YiI6IjY1Y2VlYjNlNjBjNzUxMDE2MjY4ZDUzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.M9SU7rgojORZ2P8Zv7E7tlxCeqo_W8Y0JBBRzug7Xmk';
    final tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, accesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map nowPlaying = await tmdbWithCustomLogs.v3.movies.getNowPlaying();

    List<dynamic> moviesData = nowPlaying['results'];
    List<Movie> fetchedMovies = [];
    for (var i in moviesData) {
      fetchedMovies.add(Movie.fromJson(i));
    }

    setState(() {
      movies = fetchedMovies;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushNamedAndRemoveUntil(
        context, './welcomescreen', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                logout();
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text("L O G O U T"),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _fetchMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.red,
                      size: 40,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w400${movies[0].posterPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black],
                                    stops: [0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 152, 151, 151),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                ),
                                onPressed: () async {},
                                child: const Text('Play'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending Now",
                            style: GoogleFonts.abel(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "See all",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              height: 150,
                              width: 120,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w400${movies[index].posterPath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(movies[index].title),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
