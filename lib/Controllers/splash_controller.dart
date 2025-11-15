import 'package:get/get.dart';
import '../Controllers/movie_controller.dart';

class SplashController extends GetxController {
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize the movie controller
    final MovieController movieController = Get.put(
      MovieController(),
      permanent: true,
    );

    // Wait for at least 2 seconds for splash screen animation AND fetch movies
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      movieController.fetchPopularMovies(),
    ]);

    // Ensure movies are loaded and not in loading state
    if (!movieController.isLoading.value &&
        movieController.movieItems.isNotEmpty) {
      // Mark as initialized
      isInitialized.value = true;
      
      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 400));
      
      // Navigate to home screen
      Get.offAllNamed('/');
    } else if (!movieController.isLoading.value) {
      // Movies finished loading but empty (error case)
      // Still navigate, will show error screen
      isInitialized.value = true;
      Get.offAllNamed('/');
    } else {
      // If still loading after 2 seconds, wait a bit more
      await Future.delayed(const Duration(milliseconds: 500));
      isInitialized.value = true;
      Get.offAllNamed('/');
    }
  }
}

