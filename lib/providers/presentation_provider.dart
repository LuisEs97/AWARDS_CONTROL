import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../models/nominee.dart';

final presentationProvider = StateNotifierProvider<PresentationNotifier, int>(
  (ref) => PresentationNotifier(),
);

class PresentationNotifier extends StateNotifier<int> {
  PresentationNotifier() : super(0);

  void nextNominee(int total) {
    if (state < total - 1) state++;
  }

  void reset() => state = 0;

  void previousNominee() {
    if (state > 0) state--;
  }
}

final categoriesProvider = Provider<List<Category>>((ref) {
  return [
    Category(
      title: 'Tryhard del año',
      nominees: [
        Nominee(name: 'Carrasco', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Ramon bolero', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Paco', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'Prime del año',
      nominees: [
        Nominee(name: 'Luis', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Paco', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Raul', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'ANTIPRIME del año',
      nominees: [
        Nominee(name: 'Raul', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Daniel', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Ramon', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'Evento alcoholico del año',
      nominees: [
        Nominee(
          name: 'Cumpleaños de Daniel',
          imagePath: 'assets/images/default.jpg',
        ),
        Nominee(
          name: 'Concierto Pendulum',
          imagePath: 'assets/images/default.jpg',
        ),
        Nominee(
          name: 'Fin de año piscina',
          imagePath: 'assets/images/default.jpg',
        ),
      ],
    ),

    Category(
      title: 'El más cachondo',
      nominees: [
        Nominee(name: 'Carrasco', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Ruben', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Paco', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'Repo video del año',
      nominees: [
        Nominee(
          name: 'A ese tio hay que salvarlo',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/Salvarlo.mp4',
        ),
        Nominee(
          name: 'Me esta mirando',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/Me_esta_mirando.mp4',
        ),
        Nominee(
          name: 'Despolle y muerte',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/Despolle_y_muerte.mp4',
        ),
        Nominee(
          name: 'Chupa culos',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/chupa_culos.mp4',
        ),
      ],
    ),

    Category(
      title: 'Bufada del año',
      nominees: [
        Nominee(
          name: 'Ramón → me quitan la mitad de lo que gano',
          imagePath: 'assets/images/default.jpg',
        ),
        Nominee(
          name: 'Ramón → ¡Juegas muy mal al poker!',
          imagePath: 'assets/images/poker.png',
        ),
        Nominee(
          name: 'Paco → Lo que falla el guiri',
          imagePath: 'assets/videos/duro_lo_que_acaba_de_fallar_el_guiri.mp4',
        ),
      ],
    ),

    Category(
      title: 'Tanqueada del año',
      nominees: [
        Nominee(name: 'Ruben', imagePath: 'assets/images/ruben_ds.jpg'),
        Nominee(name: 'Carrasco', imagePath: 'assets/images/carrasco_ds.png'),
      ],
    ),

    Category(
      title: 'Foto / GIF del año',
      nominees: [
        Nominee(
          name: 'Awards futbol',
          imagePath: 'assets/images/awards_futtbol.jpg',
        ),
        Nominee(
          name: 'Parálisis del sueño',
          imagePath: 'assets/images/paralisis_del_sueno.jpg',
        ),
        Nominee(name: 'Paco feliz', imagePath: 'assets/images/paco feliz.jpg'),
        Nominee(
          name: 'Luffy alcohólico',
          imagePath: 'assets/images/lufy_alcoholico.jpeg',
        ),
        Nominee(name: 'Luis calvo', imagePath: 'assets/images/calvo.webp'),
        Nominee(name: 'Raul gordo', imagePath: 'assets/images/raul_gordo.gif'),
      ],
    ),
    Category(
      title: 'Borracho del año',
      nominees: [
        Nominee(name: 'Daniel', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Paco', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Raul', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Ruben', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'Video del año',
      nominees: [
        Nominee(
          name: 'Piedra papel tijera',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/piedra_papel_tijera.mp4',
        ),
        Nominee(
          name: 'Club de los 100',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/club_de_los_100.mp4',
        ),
        Nominee(
          name: 'Es un V8',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/es_un_v8.mp4',
        ),
        Nominee(
          name: 'Baile épico',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/baile_epico.mp4',
        ),
        Nominee(
          name: 'M30',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/m30.mp4',
        ),
      ],
    ),

    Category(
      title: 'Entro en 5 minutos',
      nominees: [
        Nominee(name: 'Daniel', imagePath: 'assets/images/default.jpg'),
        Nominee(name: 'Carrasco', imagePath: 'assets/images/default.jpg'),
      ],
    ),

    Category(
      title: 'Juego del año',
      nominees: [
        Nominee(name: 'Repo', imagePath: 'assets/images/repo.jpg'),
        Nominee(name: 'Silksong', imagePath: 'assets/images/silksong.jpg'),
        Nominee(name: 'Monster Hunter', imagePath: 'assets/images/mh.jpg'),
        Nominee(name: 'Peak', imagePath: 'assets/images/peak.jpg'),
        Nominee(name: 'Straftat', imagePath: 'assets/images/straftat.jpg'),
      ],
    ),

    Category(
      title: 'Video IA del año',
      nominees: [
        Nominee(
          name: 'Ramon y Luis enrollada',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/morreo.mp4',
        ),
        Nominee(
          name: '6 7',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/6_7.mp4',
        ),
        Nominee(
          name: 'Carrasco metralleta',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/carras_uzi.mp4',
        ),
        Nominee(
          name: 'Raul pistola portátil',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/pistola_pc.mp4',
        ),
        Nominee(
          name: 'No a las drogas',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/No_a_las_drogas.mp4',
        ),
        Nominee(
          name: 'Los super awards',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/super_awards.mp4',
        ),
      ],
    ),

    Category(
      title: 'TikTok del año',
      nominees: [
        Nominee(
          name: 'Bombardino cocodrilo',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/bombardino.mp4',
        ),
        Nominee(
          name: 'Sahur remix',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/sahur_remix.mp4',
        ),
        Nominee(
          name: 'Berenjena clean',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/clean.mp4',
        ),
        Nominee(
          name: 'Disparos',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/pistolero.mp4',
        ),
      ],
    ),

    Category(
      title: 'Sticker del año',
      nominees: [
        Nominee(
          name: 'Raul cerveza',
          imagePath: 'assets/images/barriga_cerveza.webp',
        ),
        Nominee(
          name: 'Entrando a tu cuca',
          imagePath: 'assets/images/entrando_a_tu_cuca.webp',
        ),
        Nominee(
          name: 'Estírame esta',
          imagePath: 'assets/images/estirame_esta.webp',
        ),
        Nominee(name: 'Ramon gym', imagePath: 'assets/images/ramon_gym.webp'),
        Nominee(
          name: 'Hard work',
          imagePath: 'assets/images/hard_work_description.webp',
        ),
        Nominee(
          name: 'Hombre polla',
          imagePath: 'assets/images/hombrepolla.webp',
        ),
      ],
    ),

    Category(
      title: 'Rager del año',
      nominees: [
        Nominee(name: 'Paco', imagePath: 'assets/images/paco_enfadado.gif'),
        Nominee(
          name: 'Carrasco',
          imagePath: 'assets/images/carras_enfadado.gif',
        ),
        Nominee(name: 'Ramon', imagePath: 'assets/images/ramon_enfadado.gif'),
      ],
    ),

    Category(
      title: 'Audio del año',
      nominees: [
        Nominee(
          name: 'Ramón alquiler',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/audio_god.mpeg',
        ),
        Nominee(
          name: 'Carrasco mimimi',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/carrasco_mimimimi.opus',
        ),
      ],
    ),

    Category(
      title: 'Flameada del año',
      nominees: [
        Nominee(
          name: 'Carrasco yamal',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/Carrasco_yamal.opus',
        ),
        Nominee(
          name: 'Ruben Jr',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/Ruben_jr.opus',
        ),
        Nominee(
          name: 'Daniel fantasy',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/daniel_venta_roja.opus',
        ),
      ],
    ),

    Category(
      title: 'Flameada Pacal anual',
      nominees: [
        Nominee(name: 'Paco gym', imagePath: 'assets/images/rageoWasapil.png'),
        Nominee(
          name: 'Paco coche',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/paco_rageo_coche.opus',
        ),
        Nominee(
          name: 'Paco of Exilie',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/Paco_of_Exile.mp3',
        ),
      ],
    ),

    Category(
      title: 'Mejor canción del año',
      nominees: [
        Nominee(
          name: 'La leyenda de la amistad',
          imagePath: 'assets/images/default.jpg',
          audioPath: 'assets/audios/La_leyenda_de_la_amistad.mp3',
        ),
      ],
    ),

    Category(
      title: 'Delito de odio',
      nominees: [
        Nominee(
          name: 'Tier list racismo',
          imagePath: 'assets/images/racistPicture.png',
        ),
        Nominee(
          name: 'Ruben alimentación',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/Ruben_alimentacion.mp4',
        ),
        Nominee(
          name: 'Coche de maricon',
          imagePath: 'assets/images/default.jpg',
          videoPath: 'assets/videos/no_soy_tan_maricon.mp4',
        ),
      ],
    ),
  ];
});
