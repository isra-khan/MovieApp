import 'package:flutter/material.dart';

class Movie {
  int id;
  String title;
  String image;
  String director;
  String rating;
  String duration;
  String price;
  String? overview; // For movie description

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.director,
    required this.rating,
    required this.duration,
    required this.price,
    this.overview,
  });

  // Factory constructor to parse TMDB popular movies JSON
  factory Movie.fromTmdbJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      image: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750?text=No+Image',
      director: json['release_date'] != null
          ? 'Released: ${json['release_date']}'
          : 'Unknown Release Date',
      rating: json['vote_average'] != null
          ? json['vote_average'].toStringAsFixed(1)
          : '0.0',
      duration:
          '${((json['runtime'] ?? 120) ~/ 60)}h:${((json['runtime'] ?? 120) % 60)}m',
      price: '${(json['vote_average'] ?? 5.0 * 50).toStringAsFixed(0)}',
      overview: json['overview'],
    );
  }

  // Factory constructor to parse TMDB movie details JSON
  factory Movie.fromTmdbDetailJson(Map<String, dynamic> json) {
    // Format runtime as duration
    String formatDuration(int? runtime) {
      if (runtime == null) return '2h:0m';
      final hours = runtime ~/ 60;
      final minutes = runtime % 60;
      return '${hours}h:${minutes}m';
    }

    // Get director from crew (if available)
    String getDirector(List<dynamic>? crew) {
      if (crew == null) return 'Unknown Director';
      try {
        final director = crew.firstWhere(
          (person) => person['job'] == 'Director',
        );
        return 'Directed by ${director['name']}';
      } catch (e) {
        return 'Unknown Director';
      }
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      image: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750?text=No+Image',
      director: json['credits'] != null
          ? getDirector(json['credits']['crew'])
          : (json['release_date'] != null
                ? 'Released: ${json['release_date']}'
                : 'Unknown Release Date'),
      rating: json['vote_average'] != null
          ? json['vote_average'].toStringAsFixed(1)
          : '0.0',
      duration: formatDuration(json['runtime']),
      price: '${(json['vote_average'] ?? 5.0 * 50).toStringAsFixed(0)}',
      overview: json['overview'] ?? 'No description available.',
    );
  }
}

List<String> time = ['8am', '11am', '1pm', '3pm', '6pm', '8pm'];
List<Color> colors = [
  Colors.green,
  Colors.black,
  Colors.purple,
  Colors.amber,
  Colors.blueGrey,
  Colors.deepPurple,
  Colors.yellow,
];
