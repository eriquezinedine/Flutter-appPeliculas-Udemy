import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouser.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_response.dart';


class MoviesProvider extends ChangeNotifier {

  final String _apiKey    = 'c95c393ca3bb395ab68b494c233cb045';
  final String _baseUrl   = 'api.themoviedb.org';
  final String _language  = 'es-Es';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map< int , List<Cast> > moviesCast = {};

  int _popularPage = 0;

  final debouncer =  Debouncer(
    duration: const Duration( milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider(){
    print('INICIALIZO UNA CLASE');
    getOnDisplayMovies();
    getPopularMovies();
  }


    Future<String> _getJsonData( String endpoint,[int page = 1] ) async{
    final url = Uri.https(_baseUrl,endpoint,{
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);

    return response.body;
  }


  getOnDisplayMovies() async{
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse =  NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners(); //!Cambia la informacion en todos los widget que lo escuchen
  }




  getPopularMovies() async{
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage );
    final popularResponse =  PopularResponse.fromJson(jsonData);

    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    print(popularMovies[0].title);
    notifyListeners(); //!Cambia la informacion en todos los widget que lo escuchen
  }

  Future<List<Cast>>  getMovieCast(int movieId) async{ //! El async transforma cuanlquier retorno en un Future

    //*** Compruebo si existe en mi cache un movie con esa pelicula, para poder retornarlo
    // ! Nota: Esto servira mas adelante para hacer un carrito de compras;

    //? Servira Porque no tendre que mapear para conseguir un dato, simplemente lo busco
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

     print('Estoy pidiendo informacion al servidor');

    final jsonData = await _getJsonData('3/movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }


  Future<List<Movie>> searchMovie(String query) async{
    final url = Uri.https(_baseUrl,'3/search/movie',{
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }


  void getSuggestionsByQuery(String query ){
     debouncer.value ='';
     debouncer.onValue = (value) async {
      //  print('zinedine valor a buscar $value'); // *** ESTO SE EMITE CADA VES QUE DEJO DE ESCRIBIR
      final resuelts = await this.searchMovie(value);
      _suggestionStreamController.add(resuelts);
     };
        debouncer.value = query;
  }

  //* Como funciona los Stream ver el siguiente video 

}