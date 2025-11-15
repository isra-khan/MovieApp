import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Controllers/detail_controller.dart';
import '../Model/model.dart' show time, colors;

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.put(DetailController());
    final Size size = MediaQuery.of(context).size;

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty ||
          controller.movie.value == null) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Movie not found',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final movieId = Get.arguments as int;
                    controller.fetchMovieDetails(movieId);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final movie = controller.movie.value!;

      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: size.height * 0.61,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Hero(
                  tag: movie.id,
                  transitionOnUserGestures: true,
                  child: Image.network(
                    movie.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error, size: 50)),
                      );
                    },
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Transform.translate(
                    offset: const Offset(0, 1),
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 65,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    color: Colors.white,
                    height: size.height * 0.85,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInUp(
                                    child: Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 200),
                                    child: Text(
                                      movie.director,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            FadeInUp(
                              child: Text(
                                " Ticket: \$${movie.price}.00",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: Text(
                            movie.overview ?? "No description available.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: const Text(
                            " Movies Shows Time",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: time.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.updateSelectedColor(index);
                                },
                                child: FadeInUp(
                                  delay: Duration(milliseconds: (index * 100)),
                                  child: Obx(
                                    () => AnimatedContainer(
                                      duration: const Duration(
                                        microseconds: 400,
                                      ),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width:
                                              controller.selectedColor.value ==
                                                  index
                                              ? 3
                                              : 0,
                                          color:
                                              controller.selectedColor.value ==
                                                  index
                                              ? Colors.blue
                                              : Colors.transparent,
                                        ),
                                        shape: BoxShape.circle,
                                        color:
                                            controller.selectedColor.value ==
                                                index
                                            ? colors[index]
                                            : colors[index].withOpacity(0.5),
                                      ),
                                      height: 60,
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          time[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                controller
                                                        .selectedColor
                                                        .value ==
                                                    index
                                                ? Colors.white
                                                : Colors.black54,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 140,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Check Out",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
    });
  }
}
