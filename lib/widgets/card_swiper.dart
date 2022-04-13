import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //*** SOLUCION FERNANDO: agrego dos return    */
    final _size = MediaQuery.of(context).size;
    if( movies.isEmpty ){
      return SizedBox(
        width: double.infinity,
        height: _size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
        width: double.infinity,
        height: _size.height * 0.5,
        child: Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemWidth: _size.width * 0.6,
          itemHeight: _size.height * 0.4,
          itemBuilder: ( _ , int index) {
            final movie = movies[index];
            movie.heroId = 'swiper-${movie.id}';

            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'details',
                  arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(movie.fullPosterImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        )
    );


    //***  Solucion de una persona de internet, el caso si la imagenes estan basias */
    // return Container(
    //     width: double.infinity,
    //     height: _size.height * 0.5,
    //     child: movies.length >2  
    //       ? Swiper(
    //       itemCount: movies.length,
    //       layout: SwiperLayout.STACK,
    //       itemWidth: _size.width * 0.6,
    //       itemHeight: _size.height * 0.4,
    //       itemBuilder: ( _ , int index) {
    //         final movie = movies[index];
    //         return GestureDetector(
    //           onTap: () => Navigator.pushNamed(context, 'details',
    //               arguments: 'movie-instance'),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(30),
    //             child: FadeInImage(
    //               placeholder: AssetImage('assets/no-image.jpg'),
    //               image: NetworkImage(movie.fullPosterImg),
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         );
    //       },
    //     ) :null
    // );
  }
}