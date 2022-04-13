import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {

  final int movieId;

  const CastingCard({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: movieProvider.getMovieCast(movieId),
      builder: ( _ , AsyncSnapshot<List<Cast>>  snapshot) {

        if( !snapshot.hasData ){
           return const SizedBox(
             height: 180,
             child: Center(child: CircularProgressIndicator()),
           );
        }

        final List<Cast> cast = snapshot.data!; //! Como ya valide si llega informacion entonces puedo utilizar

           return Container(
             margin: EdgeInsets.only(bottom: 30),
             width: double.infinity,
             height: 180,
             child: ListView.builder(
               itemCount: 10,
               scrollDirection: Axis.horizontal,
               itemBuilder: ( _ ,index)=> _CastCard( actor: cast[index])
             ),
           );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 10),
      width: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox( height: 5,),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}