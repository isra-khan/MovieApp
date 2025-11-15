import 'package:get/get.dart';
import '../Model/model.dart';
import '../Services/movie_service.dart';

class DetailController extends GetxController {
  final Rx<Movie?> movie = Rx<Movie?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedColor = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final movieId = Get.arguments as int;
    fetchMovieDetails(movieId);
  }

  Future<void> fetchMovieDetails(int movieId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final movieDetails = await MovieService.getMovieDetails(movieId);

      movie.value = movieDetails;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Error loading movie details: $e';
    }
  }

  void updateSelectedColor(int index) {
    selectedColor.value = index;
  }
}
