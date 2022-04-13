import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider =  Provider.of<MoviesProvider>(context, listen: true); //Listen verifica si hay un cambio entonces lo redibuja 



    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: ()=>showSearch(context: context, delegate: MovieSearchDelegate())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             CardSwiper(movies: moviesProvider.onDisplayMovies,  ),
             MovieSlider(movies: moviesProvider.popularMovies, title: 'Popular!',onNextPage: ()=>moviesProvider.getPopularMovies(), )
          ],
        ),
      )
    );
  }
}