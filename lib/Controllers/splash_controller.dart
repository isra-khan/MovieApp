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
    final MovieController movieController = Get.put(
      MovieController(),
      permanent: true,
    );

    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      movieController.fetchPopularMovies(),
    ]);

    if (!movieController.isLoading.value &&
        movieController.movieItems.isNotEmpty) {
      isInitialized.value = true;

      await Future.delayed(const Duration(milliseconds: 400));

      Get.offAllNamed('/');
    } else if (!movieController.isLoading.value) {
      isInitialized.value = true;
      Get.offAllNamed('/');
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      isInitialized.value = true;
      Get.offAllNamed('/');
    }
  }
}
