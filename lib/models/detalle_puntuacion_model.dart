/*class DetallePuntuacion {
  final String idUsuario;
  final String idManga;
  final double numeroEstrellas;
  final double puntaje;

  DetallePuntuacion({
    required this.idUsuario,
    required this.idManga,
    required this.numeroEstrellas,
    required this.puntaje,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'idManga': idManga,
      'numeroEstrellas': numeroEstrellas,
      'puntaje': puntaje,
    };
  }
}
*/
class DetallePuntuacion {
  final String idUsuario;
  final String idManga;
  final double numeroEstrellas;
  final String nombreManga;
  final String usuario;

  DetallePuntuacion({
    required this.idUsuario,
    required this.idManga,
    required this.numeroEstrellas,
    required this.nombreManga,
    required this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'idManga': idManga,
      'numeroEstrellas': numeroEstrellas,
      'nombreManga': nombreManga,
      'usuario': usuario,
    };
  }
}
