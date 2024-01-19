import 'package:com.example.app_movil_proyecto_final/Screens/admin_pagina_principal.dart';
import 'package:com.example.app_movil_proyecto_final/Screens/recuperar_password.dart';
import 'package:com.example.app_movil_proyecto_final/Screens/loading_manager.dart';
import 'package:com.example.app_movil_proyecto_final/Screens/register_page.dart';
import 'package:com.example.app_movil_proyecto_final/fetch_screen.dart';
import 'package:com.example.app_movil_proyecto_final/provider/dark_theme_provider.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/primary_button.dart';
import 'package:com.example.app_movil_proyecto_final/widgets/textos_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../otros componentes/theme.dart';
import '../widgets/login_form.dart';

final images = [
  "https://img.europapress.es/fotoweb/fotonoticia_20180210183601_1200.jpg",
  "https://cdn.atomix.vg/wp-content/uploads/2022/04/New-Project-58.jpg",
  "https://guiltybit.com/wp-content/uploads/2022/07/Son-Gohan-Dragon-Ball.webp",
  "https://cdn.shopify.com/s/files/1/0399/1833/8203/files/broly-dragon-ball_2048x2048.jpg?v=1616868885",
  "https://e.rpp-noticias.io/xlarge/2018/11/22/484448_715070.jpg",
];

int activeIndex = 0;

class LoginPage extends StatefulWidget {
  //static const routeName = "/LoginScreenState"; //ruta de la interfaz
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool validarCampos() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Campos vacíos'),
            content: Text('Por favor, ingresa tu correo y contraseña.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  void loguearUsuario() async {
    try {
      //AUTENTICACION DE CORREO Y CONTRAÑA
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const FetchScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //ERROR EN EL CORREO
        errorEmailMessage();
      } else if (e.code == 'wrong-password') {
        //ERROR EN LA CONTRASEÑA
        errorPasswordMessage();
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Verifica si el usuario ya existe en Firestore
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (userDoc.exists) {
            // Usuario ya existe, redirige al MainScreenUsuario
            print('Usuario ya existe en Firestore');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPaginaPrincipal(),
              ),
            );
          } else {
            // Usuario no existe, agrégalo a la colección 'users'
            final List<String> nameParts = user.displayName!.split(" ");
            final String firstName =
                nameParts.isNotEmpty ? nameParts.first : "";
            final String lastName = nameParts.length > 1 ? nameParts.last : "";

            // Recupera el correo electrónico directamente del proveedor de Google
            final GoogleSignInAccount? googleSignInAccount =
                await googleSignIn.signInSilently();
            final String userEmail = googleSignInAccount?.email ?? '';

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'userId': user.uid,
              'correo': userEmail,
              'usuario': user.displayName,
              'nombres': firstName,
              'apellidos': lastName,
              'fecha_registro': DateTime.now(),
              'isAdmin': false,
            });

            print('Inicio de sesión con Google exitoso: ${user.displayName}');
            print('Correo almacenado en Firestore: $userEmail');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPaginaPrincipal(),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con Google aquí
      print('Error al iniciar sesión con Google: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void errorEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Correo incorrecto y/o no registrado'),
          );
        });
  }

  void errorPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Contraseña incorrecta y/o no registrada'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
        body: LoadingManager(
      isLoading: _isLoading,
      child: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 2)),
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = images[index];
                  return buildImage(urlImage, index);
                },
              ),
              SizedBox(
                height: 10,
              ),

              Center(
                child: TextosWidget(
                  text: 'LATIN MANGA',
                  color: color,
                  textSize: 32,
                  isTitle: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),

              LogInForm(
                controller: emailController,
                hintText: 'Correo',
                obscureText: false,
              ),

              SizedBox(
                height: 20,
              ),
              LogInForm(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RecuperarPassword();
                        }));
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        //style: TextStyle(color: Colors.grey[600]),
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              GestureDetector(
                child: PrimaryButton(
                  text: 'Ingresar',
                  onTap: () {
                    if (validarCampos()) {
                      loguearUsuario();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O ingresa con',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 25,
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'iconos/google.png',
                      height: 40,
                    ),
                    Text(
                      'Ingresar con Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterPage();
                        }));
                      },
                      child: const Text(
                        '¡Regístrate!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //TEMA OSCURO DE PANTALLA
              SwitchListTile(
                title: Text('Theme'),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  setState(() {
                    themeState.setDarkTheme = value;
                  });
                },
                value: themeState.getDarkTheme,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      );
}
