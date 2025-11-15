import 'package:get/get.dart';
import '../Model/model.dart';
import '../Services/movie_service.dart';

class MovieController extends GetxController {
  final RxList<Movie> movieItems = <Movie>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch - will be called explicitly from splash screen
  }

  Future<void> fetchPopularMovies() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final movies = await MovieService.getPopularMovies();

      movieItems.value = movies;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error loading movies: $e';
    }
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  void navigateToDetail(int movieId) {
    Get.toNamed('/detail', arguments: movieId);
  }
}
