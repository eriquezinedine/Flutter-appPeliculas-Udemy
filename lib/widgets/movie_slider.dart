import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  const MovieSlider({
    Key? key,
    required this.movies,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        widget.onNextPage();
        print('Obtener siguiente pagina');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    if (widget.movies.isEmpty) {
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
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.title.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                )),
          const SizedBox(height: 7),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) {
                return _MoviePoster(
                  movie: widget.movies[index],
                  heroeId: '${widget.title}-${index}-${widget.movies[index].id} ',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroeId;
  const _MoviePoster({Key? key, required this.movie, required this.heroeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroeId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(movie.fullBackdropPath),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            movie.title,
            maxLines: 2, //Llega al fondo crea una nueva linea
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
