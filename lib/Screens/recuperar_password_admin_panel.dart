/*import 'package:com.example.app_movil_proyecto_final/widgets/login_form.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarPasswordAdminPanel extends StatefulWidget {
  RecuperarPasswordAdminPanel({super.key});

  @override
  State<RecuperarPasswordAdminPanel> createState() =>
      _RecuperarPasswordAdminPanelState();
}

class _RecuperarPasswordAdminPanelState
    extends State<RecuperarPasswordAdminPanel> {
  final emailController = TextEditingController();

  void Dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  '¡El link para resear tu contraseña fue enviado!, revisa tu correo'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                '¡El correo no existe!, no se pudo restaurar la contraseña',
              ),
            );
          });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        /*Swiper(
          duration: 800,
          autoplayDelay: 8000,
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              Constss.authImagesPaths2[index],
              fit: BoxFit.cover,
            );
          },
          autoplay: true,
          itemCount: Constss.authImagesPaths2.length,
        ),*/
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              TextosWidget(
                text: '¿PROBLEMAS PARA INGRESAR?',
                color: Colors.redAccent,
                textSize: 22,
                isTitle: true,
              ),
              SizedBox(
                height: 40,
              ),
              TextosWidget(
                text:
                    'Ingresa tu correo electrónico para enviarte un enlace y resetear contraseña',
                color: Colors.white,
                textSize: 30,
                isTitle: true,
              ),
              SizedBox(
                height: 160,
              ),
              LogInForm(
                controller: emailController,
                hintText: 'Correo',
                obscureText: false,
              ),
              SizedBox(
                height: 120,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: MaterialButton(
                  child: Text(
                    'Enviar enlace',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Tamaño de fuente del texto del botón
                    ),
                  ),
                  color: Colors.green,
                  height: 50, // Ajustar el tamaño del botón
                  onPressed: () {
                    passwordReset();
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Quieres retroceder?',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
*/

import 'package:com.example.app_movil_proyecto_final/otros%20componentes/contss.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarPasswordAdminPanel extends StatefulWidget {
  RecuperarPasswordAdminPanel({super.key});

  @override
  State<RecuperarPasswordAdminPanel> createState() =>
      _RecuperarPasswordAdminPanelState();
}

class _RecuperarPasswordAdminPanelState
    extends State<RecuperarPasswordAdminPanel> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '¡El enlace para restablecer tu contraseña fue enviado! Revise su correo.',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '¡El correo no existe! No se pudo restablecer la contraseña.',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Swiper(
            duration: 800,
            autoplayDelay: 8000,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                Constss.authImagesPaths2[index],
                fit: BoxFit.cover,
              );
            },
            autoplay: true,
            itemCount: Constss.authImagesPaths2.length,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                TextosWidget(
                  text: '¿PROBLEMAS PARA INGRESAR?',
                  color: Colors.redAccent,
                  textSize: 22,
                  isTitle: true,
                ),
                SizedBox(
                  height: 40,
                ),
                TextosWidget(
                  text:
                      'Ingresa tu correo electrónico para enviarte un enlace y restablecer la contraseña',
                  color: Colors.white,
                  textSize: 30,
                  isTitle: true,
                ),
                SizedBox(
                  height: 160,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo',
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      passwordReset();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Enviar enlace',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Esto retrocede al screen anterior
                  },
                  child: Text(
                    '¿Quieres retroceder?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
