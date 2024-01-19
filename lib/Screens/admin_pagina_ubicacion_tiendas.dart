import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class AdminPaginaUbicacionTiendas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tiendas'),
      ),
      body: TiendasList(),
    );
  }
}

class TiendasList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> tiendasData = [
      {
        'nombre': 'Tienda - CLUB DEL CÓMIC MONTEVIDEO',
        'direccion': 'Montevideo 255, C1019 CABA',
        'horario': 'Lunes a Sábado: 11am - 7pm ',
        'celular': '+541143752323',
        'ciudad': 'Buenos Aires, Argentina',
        'imageUrl':
            'https://lh5.googleusercontent.com/p/AF1QipOrszoBQFDEUaF4dTFT8Yyyk6UMfP2FF_oCBFf9=w408-h906-k-no',
        'ubicacion':
            'https://www.google.com/maps/place/Tienda+-+CLUB+DEL+C%C3%93MIC+MONTEVIDEO/@-34.6047278,-58.4052834,15z/data=!4m6!3m5!1s0x95bccac38cd96b13:0xe7fd376d1ff17852!8m2!3d-34.6060305!4d-58.3892765!16s%2Fg%2F1vyk3ps7?entry=ttu',
      },
      {
        'nombre': 'Tienda - Entelequia',
        'direccion': 'Uruguay 341, C1015ABG CABA',
        'horario': 'Lunes a Viernes: 10am - 7pm y Sábado: 11am - 7pm',
        'celular': '+541143727282',
        'ciudad': 'Buenos Aires, Argentina',
        'imageUrl':
            'https://lh5.googleusercontent.com/p/AF1QipNJUJpJRTfP76J5ZlyTi-nPjPEFq-NzC6oA4bvv=w426-h240-k-no',
        'ubicacion':
            'https://www.google.com/maps/place/Tienda+-+Entelequia/@-34.604764,-58.4052834,15z/data=!3m1!5s0x95bccac436aebc63:0x86fbd69698aaeb04!4m6!3m5!1s0x95bccac4373c8a83:0x94955b3e0f1263e2!8m2!3d-34.604764!4d-58.386229!16s%2Fg%2F11b6mgmdgm?entry=ttu',
      },
      {
        'nombre': 'LA REViSTERiA – Comics [Centro]',
        'direccion': 'Av. Corrientes 1384, C1043 ABN, Buenos Aires',
        'horario': 'Lunes a Sábado: 9:30am - 9pm y Domingo: 1 - 9pm',
        'celular': '+541139870661',
        'ciudad': 'Buenos Aires, Argentina',
        'imageUrl':
            'https://lh5.googleusercontent.com/p/AF1QipP1Ip2H99y2xNTOdYAShltBc2voHptyM_dMO_o=w408-h306-k-no',
        'ubicacion':
            'https://www.google.com/maps/place/LA+REViSTERiA+%E2%80%93+Comics+%5BCentro%5D/@-34.6046916,-58.4052834,15z/data=!4m6!3m5!1s0x95bccac42b93c825:0x656ebca8ac1a01da!8m2!3d-34.6041082!4d-58.3862507!16s%2Fg%2F11b6lk5qj1?entry=ttu',
      },
      {
        'nombre': 'LA REViSTERiA – Comics & Coffee [Microcentro]',
        'direccion': 'Florida 719, C1053 CABA',
        'horario':
            'Lunes a Jueves: 9:30am - 8pm, Viernes y Sábados: 9:30am - 9pm y Domingo: 12 - 8pm',
        'celular': '+541152192446',
        'ciudad': 'Buenos Aires, Argentina',
        'imageUrl':
            'https://lh5.googleusercontent.com/p/AF1QipM1yGjv24qKIFAoubBEtJh6RsWdZV0hEe_HYH0h=w426-h240-k-no',
        'ubicacion':
            'https://www.google.com/maps/place/LA+REViSTERiA+%E2%80%93+Comics+%26+Coffee+%5BMicrocentro%5D/@-34.6046916,-58.4052834,15z/data=!4m6!3m5!1s0x95bccacc6819c78d:0x4e76ee844cc7d580!8m2!3d-34.5995961!4d-58.3752693!16s%2Fg%2F11bwgwflxz?entry=ttu',
      },
      {
        'nombre': 'Momo Manga',
        'direccion': 'Uruguay 263 1° piso, C1015 CABA',
        'horario': 'Jueves - Viernes: 12 - 5pm y Sábado y Domingo: 12 - 6pm',
        'celular': 'NO TIENE',
        'ciudad': 'Buenos Aires, Argentina',
        'imageUrl':
            'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=kxbR6yLcIdEIxW7wCy_-pA&cb_client=search.gws-prod.gps&w=408&h=240&yaw=82.559906&pitch=0&thumbfov=100',
        'ubicacion':
            'https://www.google.com/maps/place/Edificio+Simons/@-34.6057915,-58.388834,17z/data=!3m2!4b1!5s0x95bccac4522ea4d1:0x8fa17ac860fa6a3!4m14!1m7!3m6!1s0x95bccb514037618d:0xa0fe8d5d45acad4d!2sMomo+Manga!8m2!3d-34.6058033!4d-58.3863389!16s%2Fg%2F11hlpjkbpl!3m5!1s0x95bccac45228af2f:0xd45627a0e1512b67!8m2!3d-34.6057959!4d-58.3862591!16s%2Fg%2F11fy4yn2gl?entry=ttu',
      },
    ];

    return ListView.builder(
      itemCount: tiendasData.length,
      itemBuilder: (context, index) {
        var tiendaData = tiendasData[index];

        return TiendaCard(
          nombre: tiendaData['nombre']!,
          direccion: tiendaData['direccion']!,
          horario: tiendaData['horario']!,
          celular: tiendaData['celular']!,
          ciudad: tiendaData['ciudad']!,
          imageUrl: tiendaData['imageUrl']!,
          ubicacion: tiendaData['ubicacion']!,
        );
      },
    );
  }
}

class TiendaCard extends StatelessWidget {
  final String nombre;
  final String direccion;
  final String horario;
  final String celular;
  final String ciudad;
  final String imageUrl;
  final String ubicacion;

  TiendaCard({
    required this.nombre,
    required this.direccion,
    required this.horario,
    required this.celular,
    required this.ciudad,
    required this.imageUrl,
    required this.ubicacion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Dirección: $direccion',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Horario: $horario',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Celular: $celular',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Ciudad: $ciudad',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Ubicación:',
              style: TextStyle(fontSize: 14.0),
            ),
            InkWell(
              onTap: () {
                // Abrir enlace externo a Google Maps al hacer clic
                launch(ubicacion);
              },
              child: Text(
                '$ubicacion',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
