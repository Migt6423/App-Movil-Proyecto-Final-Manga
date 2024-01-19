/*import 'package:com.example.app_movil_proyecto_final/inner_screens/OnlineViewScreen.dart';
import 'package:com.example.app_movil_proyecto_final/models/detalle_puntuacion_model.dart';
import 'package:com.example.app_movil_proyecto_final/providers/mangas_providers.dart';
import 'package:com.example.app_movil_proyecto_final/services/utils.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MangaDetails extends StatefulWidget {
  static const routeName = '/MangaDetails';

  const MangaDetails({Key? key}) : super(key: key);

  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {
  double _userRating = 0.0;
  TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final mangasProvider =
          Provider.of<MangasProvider>(context, listen: false);
      final mangaId = ModalRoute.of(context)!.settings.arguments as String;
      final getCurrManga = mangasProvider.findMangabyId(mangaId);
      _userRating = getCurrManga.rating ?? 0.0;
      final detallePuntuacionRef =
          FirebaseFirestore.instance.collection('detalle_puntuacion');
      final userUid = FirebaseAuth.instance.currentUser?.uid;

      if (userUid != null) {
        final detallePuntuacionQuery = await detallePuntuacionRef
            .where('idUsuario', isEqualTo: userUid)
            .where('idManga', isEqualTo: mangaId)
            .limit(1)
            .get();

        if (detallePuntuacionQuery.docs.isNotEmpty) {
          final detallePuntuacionDoc = detallePuntuacionQuery.docs.first;
          final userRating = detallePuntuacionDoc['numeroEstrellas'] ?? 0.0;

          // Actualiza el rating en el estado
          setState(() {
            _userRating = userRating;
          });
        }
      }

      // Cargar comentarios al inicio
      loadComments(mangaId);
    });
  }

  Future<void> _downloadPDF(String pdfUrl, String mangaTitle) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: pdfUrl,
          savedDir: '/sdcard/Download/',
          fileName: '$mangaTitle.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );

        FlutterDownloader.registerCallback((id, status, progress) {
          if (taskId == id) {
            if (status == DownloadTaskStatus.complete) {
              Fluttertoast.showToast(
                msg: '$mangaTitle se ha descargado correctamente',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            } else if (status == DownloadTaskStatus.failed) {
              Fluttertoast.showToast(
                msg: 'Descarga de $mangaTitle falló',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          }
        });
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Error al iniciar la descarga: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Permiso de almacenamiento denegado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void loadComments(String mangaId) async {
    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');
    final snapshot =
        await comentariosRef.where('idManga', isEqualTo: mangaId).get();

    setState(() {
      comments = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> deleteComment(String? mangaId, String? commentId) async {
    if (commentId == null || mangaId == null) {
      print('ID de comentario o manga nulo. No se puede eliminar.');
      return;
    }

    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');

    try {
      await comentariosRef.doc(commentId).delete();
      Fluttertoast.showToast(
        msg: 'Comentario eliminado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Recargar los comentarios después de eliminar uno
      loadComments(mangaId);
    } catch (error) {
      print('Error al eliminar comentario: $error');
    }
  }

  Future<void> showDeleteConfirmationDialog(
      String? mangaId, String? commentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Estás seguro de que deseas eliminar este comentario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await deleteComment(mangaId, commentId);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditCommentDialog(
      String? mangaId, String? commentId, String initialContent) async {
    TextEditingController _editController =
        TextEditingController(text: initialContent);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar comentario'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              hintText: 'Edita tu comentario...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await editComment(mangaId, commentId, _editController.text);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editComment(
      String? mangaId, String? commentId, String newContent) async {
    if (commentId == null || mangaId == null) {
      print('ID de comentario o manga nulo. No se puede editar.');
      return;
    }

    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');

    try {
      await comentariosRef.doc(commentId).update({
        'contenido': newContent,
      });

      Fluttertoast.showToast(
        msg: 'Comentario editado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Recargar los comentarios después de editar uno
      loadComments(mangaId);
    } catch (error) {
      print('Error al editar comentario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final mangasProvider = Provider.of<MangasProvider>(context);
    final mangaId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrManga = mangasProvider.findMangabyId(mangaId);

    //final viewedMangaProvider = Provider.of<ViewedMangaProvider>(context);
    final Brightness themeBrightness = Theme.of(context).brightness;
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextosWidget(
                text: getCurrManga.title,
                color: color,
                textSize: 25,
                isTitle: true,
              ),
            ),
            FancyShimmerImage(
              imageUrl: getCurrManga.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: _userRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              setState(() {
                                _userRating = rating;
                              });

                              if (getCurrManga != null) {
                                final mangasRef = FirebaseFirestore.instance
                                    .collection('mangas');
                                final detallePuntuacionRef = FirebaseFirestore
                                    .instance
                                    .collection('detalle_puntuacion');

                                final userUid =
                                    FirebaseAuth.instance.currentUser?.uid;

                                if (userUid != null) {
                                  final userDoc = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(userUid)
                                      .get();

                                  final userName = userDoc['usuario'];

                                  // Buscar el registro de detalle_puntuacion del usuario actual para este manga
                                  final detallePuntuacionQuery =
                                      await detallePuntuacionRef
                                          .where('idUsuario',
                                              isEqualTo: userUid)
                                          .where('idManga', isEqualTo: mangaId)
                                          .limit(1)
                                          .get();

                                  if (detallePuntuacionQuery.docs.isNotEmpty) {
                                    // Si el usuario ya votó antes, actualiza el rating en detalle_puntuacion
                                    final detallePuntuacionDoc =
                                        detallePuntuacionQuery.docs.first;
                                    final currentRating = detallePuntuacionDoc[
                                            'numeroEstrellas'] ??
                                        0.0;

                                    // Resta el voto anterior y suma el nuevo voto
                                    final newRating =
                                        (getCurrManga.rating ?? 0.0) -
                                            currentRating +
                                            _userRating;

                                    await mangasRef.doc(mangaId).update({
                                      'numeroEstrellas': newRating /
                                          (getCurrManga.numRatings ?? 1),
                                    });

                                    await detallePuntuacionDoc.reference
                                        .update({
                                      'numeroEstrellas': _userRating,
                                    });
                                  } else {
                                    // Si es la primera vez que vota, guarda la puntuación en detalle_puntuacion
                                    final newRating = (getCurrManga.rating ??
                                                0.0) *
                                            (getCurrManga.numRatings ?? 0) +
                                        _userRating /
                                            ((getCurrManga.numRatings ?? 0) +
                                                1);

                                    await mangasRef.doc(mangaId).update({
                                      'numeroEstrellas': newRating /
                                          (getCurrManga.numRatings ?? 1),
                                    });

                                    final detallePuntuacion = DetallePuntuacion(
                                      idUsuario: userUid,
                                      idManga: mangaId,
                                      numeroEstrellas: _userRating,
                                      nombreManga: getCurrManga.title,
                                      usuario: userName,
                                    );

                                    try {
                                      await detallePuntuacionRef
                                          .add(detallePuntuacion.toMap());
                                    } catch (error) {
                                      print(
                                          'Error al guardar la puntuación del usuario: $error');
                                    }
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Género: ${getCurrManga.mangaCategoryName}',
                            color: Colors.green,
                            textSize: 22,
                            isTitle: true,
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Tipo: ${getCurrManga.type}',
                            color: themeBrightness == Brightness.light
                                ? Colors.black // Color para tema claro
                                : Colors.white, // Color para tema oscuro
                            textSize: 22,
                            isTitle: true,
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Páginas: ${getCurrManga.numberPages}',
                            color: Colors.red.shade300,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botones de Ver Online y Descargar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pdfUrl = getCurrManga.pdfUrl;
                      final mangaTitle = getCurrManga.title;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnlineViewScreen(
                            pdfUrl: pdfUrl,
                            mangaTitle: mangaTitle,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Ver online',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  ElevatedButton(
                    //onPressed: () async {},
                    onPressed: () async {
                      final pdfUrl = getCurrManga.pdfUrl;
                      final mangaTitle = getCurrManga.title;

                      await _downloadPDF(pdfUrl, mangaTitle);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Descargar',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: themeBrightness == Brightness.light
                          ? Colors.black // Color para tema claro
                          : Colors.white, // Color para tema oscuro
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              comment['usuario'],
                              style: TextStyle(
                                color: themeBrightness == Brightness.light
                                    ? Colors.black // Color para tema claro
                                    : Colors.white, // Color para tema oscuro
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await showEditCommentDialog(mangaId,
                                    comment['commentId'], comment['contenido']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await showDeleteConfirmationDialog(
                                    mangaId, comment['commentId']);
                              },
                            ),
                            //Spacer(),
                          ],
                        ),
                        subtitle: Text(
                          comment['contenido'],
                          style: TextStyle(
                            color: themeBrightness == Brightness.light
                                ? Colors.black // Color para tema claro
                                : Colors.white, // Color para tema oscuro
                          ),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu comentario...',
                    ),
                    style: TextStyle(
                      color: themeBrightness == Brightness.light
                          ? Colors.black // Color para tema claro
                          : Colors.white, // Color para tema oscuro
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final userUid = FirebaseAuth.instance.currentUser?.uid;
                      final mangaTitle = getCurrManga.title;
                      final commentContent = _commentController.text;

                      if (userUid != null) {
                        final comentariosRef = FirebaseFirestore.instance
                            .collection('comentarios');

                        try {
                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid)
                              .get();

                          // Generar un nuevo ID para el comentario
                          final String commentId = comentariosRef.doc().id;
                          final userName = userDoc['usuario'];

                          await comentariosRef.doc(commentId).set({
                            'idUsuario': userUid,
                            'usuario': userName,
                            'idManga': mangaId,
                            'nombreManga': mangaTitle,
                            'contenido': commentContent,
                            'fecha': FieldValue.serverTimestamp(),
                            'commentId': commentId,
                          });

                          _commentController.clear();

                          // Recargar los comentarios después de enviar uno nuevo
                          loadComments(mangaId);

                          Fluttertoast.showToast(
                            msg: 'Comentario enviado',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        } catch (error) {
                          print('Error al enviar comentario: $error');
                        }
                      }
                    },
                    child: Text('Enviar Comentario'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/

import 'package:com.example.app_movil_proyecto_final/inner_screens/OnlineViewScreen.dart';
import 'package:com.example.app_movil_proyecto_final/models/detalle_puntuacion_model.dart';
import 'package:com.example.app_movil_proyecto_final/providers/mangas_providers.dart';
import 'package:com.example.app_movil_proyecto_final/services/utils.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MangaDetails extends StatefulWidget {
  static const routeName = '/MangaDetails';

  const MangaDetails({Key? key}) : super(key: key);

  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {
  double _userRating = 0.0;
  TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final mangasProvider =
          Provider.of<MangasProvider>(context, listen: false);
      final mangaId = ModalRoute.of(context)!.settings.arguments as String;
      final getCurrManga = mangasProvider.findMangabyId(mangaId);
      _userRating = getCurrManga.rating ?? 0.0;
      final detallePuntuacionRef =
          FirebaseFirestore.instance.collection('detalle_puntuacion');
      final userUid = FirebaseAuth.instance.currentUser?.uid;

      if (userUid != null) {
        final detallePuntuacionQuery = await detallePuntuacionRef
            .where('idUsuario', isEqualTo: userUid)
            .where('idManga', isEqualTo: mangaId)
            .limit(1)
            .get();

        if (detallePuntuacionQuery.docs.isNotEmpty) {
          final detallePuntuacionDoc = detallePuntuacionQuery.docs.first;
          final userRating = detallePuntuacionDoc['numeroEstrellas'] ?? 0.0;

          // Actualiza el rating en el estado
          setState(() {
            _userRating = userRating;
          });
        }
      }

      // Cargar comentarios al inicio
      loadComments(mangaId);
    });
  }

  Future<void> _downloadPDF(String pdfUrl, String mangaTitle) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: pdfUrl,
          savedDir: '/sdcard/Download/',
          fileName: '$mangaTitle.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );

        FlutterDownloader.registerCallback((id, status, progress) {
          if (taskId == id) {
            if (status == DownloadTaskStatus.complete) {
              Fluttertoast.showToast(
                msg: '$mangaTitle se ha descargado correctamente',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            } else if (status == DownloadTaskStatus.failed) {
              Fluttertoast.showToast(
                msg: 'Descarga de $mangaTitle falló',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          }
        });
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Error al iniciar la descarga: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Permiso de almacenamiento denegado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void loadComments(String mangaId) async {
    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');
    final snapshot =
        await comentariosRef.where('idManga', isEqualTo: mangaId).get();

    setState(() {
      comments = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> deleteComment(String? mangaId, String? commentId) async {
    if (commentId == null || mangaId == null) {
      print('ID de comentario o manga nulo. No se puede eliminar.');
      return;
    }

    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');

    try {
      await comentariosRef.doc(commentId).delete();
      Fluttertoast.showToast(
        msg: 'Comentario eliminado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Recargar los comentarios después de eliminar uno
      loadComments(mangaId);
    } catch (error) {
      print('Error al eliminar comentario: $error');
    }
  }

  Future<void> showDeleteConfirmationDialog(
      String? mangaId, String? commentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Estás seguro de que deseas eliminar este comentario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await deleteComment(mangaId, commentId);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditCommentDialog(
      String? mangaId, String? commentId, String initialContent) async {
    TextEditingController _editController =
        TextEditingController(text: initialContent);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar comentario'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              hintText: 'Edita tu comentario...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await editComment(mangaId, commentId, _editController.text);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editComment(
      String? mangaId, String? commentId, String newContent) async {
    if (commentId == null || mangaId == null) {
      print('ID de comentario o manga nulo. No se puede editar.');
      return;
    }

    final comentariosRef = FirebaseFirestore.instance.collection('comentarios');

    try {
      await comentariosRef.doc(commentId).update({
        'contenido': newContent,
      });

      Fluttertoast.showToast(
        msg: 'Comentario editado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Recargar los comentarios después de editar uno
      loadComments(mangaId);
    } catch (error) {
      print('Error al editar comentario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final mangasProvider = Provider.of<MangasProvider>(context);
    final mangaId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrManga = mangasProvider.findMangabyId(mangaId);

    //final viewedMangaProvider = Provider.of<ViewedMangaProvider>(context);
    final Brightness themeBrightness = Theme.of(context).brightness;
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextosWidget(
                text: getCurrManga.title,
                color: color,
                textSize: 25,
                isTitle: true,
              ),
            ),
            FancyShimmerImage(
              imageUrl: getCurrManga.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: _userRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              setState(() {
                                _userRating = rating;
                              });

                              if (getCurrManga != null) {
                                final mangasRef = FirebaseFirestore.instance
                                    .collection('mangas');
                                final detallePuntuacionRef = FirebaseFirestore
                                    .instance
                                    .collection('detalle_puntuacion');

                                final userUid =
                                    FirebaseAuth.instance.currentUser?.uid;

                                if (userUid != null) {
                                  final userDoc = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(userUid)
                                      .get();

                                  final userName = userDoc['usuario'];

                                  // Buscar el registro de detalle_puntuacion del usuario actual para este manga
                                  final detallePuntuacionQuery =
                                      await detallePuntuacionRef
                                          .where('idUsuario',
                                              isEqualTo: userUid)
                                          .where('idManga', isEqualTo: mangaId)
                                          .limit(1)
                                          .get();

                                  if (detallePuntuacionQuery.docs.isNotEmpty) {
                                    // Si el usuario ya votó antes, actualiza el rating en detalle_puntuacion
                                    final detallePuntuacionDoc =
                                        detallePuntuacionQuery.docs.first;
                                    final currentRating = detallePuntuacionDoc[
                                            'numeroEstrellas'] ??
                                        0.0;

                                    // Resta el voto anterior y suma el nuevo voto
                                    final newRating =
                                        (getCurrManga.rating ?? 0.0) -
                                            currentRating +
                                            _userRating;

                                    await mangasRef.doc(mangaId).update({
                                      'numeroEstrellas': newRating /
                                          (getCurrManga.numRatings ?? 1),
                                    });

                                    await detallePuntuacionDoc.reference
                                        .update({
                                      'numeroEstrellas': _userRating,
                                    });
                                  } else {
                                    // Si es la primera vez que vota, guarda la puntuación en detalle_puntuacion
                                    final newRating = (getCurrManga.rating ??
                                                0.0) *
                                            (getCurrManga.numRatings ?? 0) +
                                        _userRating /
                                            ((getCurrManga.numRatings ?? 0) +
                                                1);

                                    await mangasRef.doc(mangaId).update({
                                      'numeroEstrellas': newRating /
                                          (getCurrManga.numRatings ?? 1),
                                    });

                                    final detallePuntuacion = DetallePuntuacion(
                                      idUsuario: userUid,
                                      idManga: mangaId,
                                      numeroEstrellas: _userRating,
                                      nombreManga: getCurrManga.title,
                                      usuario: userName,
                                    );

                                    try {
                                      await detallePuntuacionRef
                                          .add(detallePuntuacion.toMap());
                                    } catch (error) {
                                      print(
                                          'Error al guardar la puntuación del usuario: $error');
                                    }
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Género: ${getCurrManga.mangaCategoryName}',
                            color: Colors.green,
                            textSize: 22,
                            isTitle: true,
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Tipo: ${getCurrManga.type}',
                            color: themeBrightness == Brightness.light
                                ? Colors.black // Color para tema claro
                                : Colors.white, // Color para tema oscuro
                            textSize: 22,
                            isTitle: true,
                          ),
                          SizedBox(height: 15),
                          TextosWidget(
                            text: 'Páginas: ${getCurrManga.numberPages}',
                            color: Colors.red.shade300,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botones de Ver Online y Descargar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pdfUrl = getCurrManga.pdfUrl;
                      final mangaTitle = getCurrManga.title;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnlineViewScreen(
                            pdfUrl: pdfUrl,
                            mangaTitle: mangaTitle,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Ver online',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  ElevatedButton(
                    //onPressed: () async {},
                    onPressed: () async {
                      final pdfUrl = getCurrManga.pdfUrl;
                      final mangaTitle = getCurrManga.title;

                      await _downloadPDF(pdfUrl, mangaTitle);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Descargar',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: themeBrightness == Brightness.light
                          ? Colors.black // Color para tema claro
                          : Colors.white, // Color para tema oscuro
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      final borderColor = themeBrightness == Brightness.light
                          ? Colors
                              .black87 // Color del contorno oscuro para tema claro
                          : Colors
                              .white; // Color del contorno blanco para tema oscuro

                      return Container(
                        margin: EdgeInsets.only(
                            bottom: 10), // Ajusta el espacio entre comentarios
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 1.5, // Ancho del contorno
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Radio de borde para hacerlo más suave
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons
                                    .account_circle, // Puedes cambiar el icono según tus preferencias
                                color: Colors.blue,
                                size: 30,
                              ),
                              SizedBox(
                                  width:
                                      10), // Agregamos un espacio para separar el icono del texto
                              Text(
                                comment['usuario'],
                                style: TextStyle(
                                  color: themeBrightness == Brightness.light
                                      ? Colors.black // Color para tema claro
                                      : Colors.white, // Color para tema oscuro
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  await showEditCommentDialog(
                                      mangaId,
                                      comment['commentId'],
                                      comment['contenido']);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await showDeleteConfirmationDialog(
                                      mangaId, comment['commentId']);
                                },
                              ),
                              //Spacer(),
                            ],
                          ),
                          subtitle: Text(
                            comment['contenido'],
                            style: TextStyle(
                              color: themeBrightness == Brightness.light
                                  ? Colors.black // Color para tema claro
                                  : Colors.white, // Color para tema oscuro
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu comentario...',
                    ),
                    style: TextStyle(
                      color: themeBrightness == Brightness.light
                          ? Colors.black // Color para tema claro
                          : Colors.white, // Color para tema oscuro
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final userUid = FirebaseAuth.instance.currentUser?.uid;
                      final mangaTitle = getCurrManga.title;
                      final commentContent = _commentController.text;

                      if (userUid != null) {
                        final comentariosRef = FirebaseFirestore.instance
                            .collection('comentarios');

                        try {
                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid)
                              .get();

                          // Generar un nuevo ID para el comentario
                          final String commentId = comentariosRef.doc().id;
                          final userName = userDoc['usuario'];

                          await comentariosRef.doc(commentId).set({
                            'idUsuario': userUid,
                            'usuario': userName,
                            'idManga': mangaId,
                            'nombreManga': mangaTitle,
                            'contenido': commentContent,
                            'fecha': FieldValue.serverTimestamp(),
                            'commentId': commentId,
                          });

                          _commentController.clear();

                          // Recargar los comentarios después de enviar uno nuevo
                          loadComments(mangaId);

                          Fluttertoast.showToast(
                            msg: 'Comentario enviado',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        } catch (error) {
                          print('Error al enviar comentario: $error');
                        }
                      }
                    },
                    child: Text('Enviar Comentario'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
