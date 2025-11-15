import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/movie_controller.dart';
import '../Model/model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MovieDisplay extends StatelessWidget {
  const MovieDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(
      MovieController(),
      permanent: true,
    );
    final Size size = MediaQuery.of(context).size;

    return Obx(() {
      if (controller.isLoading.value &&
          controller.movieItems.isEmpty &&
          controller.errorMessage.value.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 100,
            ),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchPopularMovies(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.movieItems.isEmpty) {
        return const Scaffold(body: Center(child: Text('No movies available')));
      }

      return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Obx(() {
                final currentImage = controller.movieItems.isNotEmpty
                    ? controller.movieItems[controller.currentIndex.value].image
                    : '';

                if (currentImage.isEmpty) {
                  return Container(color: Colors.black);
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Image.network(
                    currentImage,
                    key: ValueKey(currentImage),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    cacheWidth: 600,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(color: Colors.black);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[900]);
                    },
                  ),
                );
              }),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: size.height * 0.33,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.grey.shade50.withOpacity(1),
                        Colors.grey.shade50.withOpacity(1),
                        Colors.grey.shade50.withOpacity(1),
                        Colors.grey.shade100.withOpacity(1),
                        Colors.grey.shade100.withOpacity(0.0),
                        Colors.grey.shade100.withOpacity(0.0),
                        Colors.grey.shade100.withOpacity(0.0),
                        Colors.grey.shade100.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                height: size.height * 0.7,
                width: size.width,
                child: Obx(
                  () => CarouselSlider(
                    options: CarouselOptions(
                      height: 550,
                      viewportFraction: 0.7,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        controller.updateCurrentIndex(index);
                      },
                    ),
                    items: controller.movieItems.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Movie movie = entry.value;
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              controller.navigateToDetail(movie.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: movie.id,
                                        child: Container(
                                          height: 350,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.55,
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Image.network(
                                            movie.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // For movie title
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // for movie director
                                      Text(
                                        movie.director,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),

                                        opacity:
                                            controller.currentIndex.value ==
                                                index
                                            ? 1.0
                                            : 0.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    movie.rating,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    color: Colors.black45,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    movie.duration,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.21,
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.play_circle,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "Watch",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
