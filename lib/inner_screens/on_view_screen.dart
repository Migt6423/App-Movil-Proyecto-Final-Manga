import 'package:com.example.app_movil_proyecto_final/models/mangas_models.dart';
import 'package:com.example.app_movil_proyecto_final/providers/mangas_providers.dart';
import 'package:com.example.app_movil_proyecto_final/services/utils.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/back_widget.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/empty_manga_widget.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/on_view_widget.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnViewScreen extends StatelessWidget {
  static const routeName = "/OnViewScreen"; //ruta de la interfaz
  const OnViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final mangasProvider = Provider.of<MangasProvider>(context);
    List<MangasModels> allMangas = mangasProvider.getMangas;
    bool _isEmpty = allMangas.isEmpty; // Verificar si la lista está vacía
    return Scaffold(
      appBar: AppBar(
        leading: BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextosWidget(
          text: 'MANGAS POR VER',
          color: color,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: _isEmpty
          ? EmptyMangaWidget(
              text: 'Aún no hay mangas vistos',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(35),
              childAspectRatio: size.width / (size.height * 0.89),
              children: List.generate(allMangas.length, (index) {
                return ChangeNotifierProvider.value(
                  value: allMangas[index],
                  child: const OnViewWidget(),
                );
              })),
    );
  }
}
