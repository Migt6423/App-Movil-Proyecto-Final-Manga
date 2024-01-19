import 'package:com.example.app_movil_proyecto_final/otros%20componentes/contss.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/login_form.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarPassword extends StatefulWidget {
  RecuperarPassword({super.key});

  @override
  State<RecuperarPassword> createState() => _RecuperarPasswordState();
}

class _RecuperarPasswordState extends State<RecuperarPassword> {
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
              /*content: Text(
                e.message.toString(),
              ),*/
              content: Text(
                '¡El correo no existe!, no se pudo restaurar la contraseña',
              ),
            );
          });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          //padding: kDefaultPadding,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
