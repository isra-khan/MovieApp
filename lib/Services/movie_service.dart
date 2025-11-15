import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/model.dart';

class MovieService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String apiKey = 'def20fb2097f69cafc125b97feb44723';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Fetch popular movies
  static Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTmdbJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load popular movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  // Fetch movie details by ID
  static Future<Movie> getMovieDetails(int movieId) async {
    try {
      // Fetch both movie details and credits in parallel
      final detailsResponse = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US'),
      );

      final creditsResponse = await http.get(
        Uri.parse(
          '$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=en-US',
        ),
      );

      if (detailsResponse.statusCode == 200 &&
          creditsResponse.statusCode == 200) {
        final detailsData = json.decode(detailsResponse.body);
        final creditsData = json.decode(creditsResponse.body);

        // Merge credits into details data
        detailsData['credits'] = creditsData;

        return Movie.fromTmdbDetailJson(detailsData);
      } else {
        throw Exception(
          'Failed to load movie details: ${detailsResponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
}
