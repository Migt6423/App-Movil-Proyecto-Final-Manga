/*import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class AdminPaginaDonaciones extends StatefulWidget {
  const AdminPaginaDonaciones({Key? key}) : super(key: key);

  @override
  _AdminPaginaDonacionesState createState() => _AdminPaginaDonacionesState();
}

class _AdminPaginaDonacionesState extends State<AdminPaginaDonaciones> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Ayúdanos a crecer!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selecciona una opción de donación',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              DonationOption(
                label: 'Tarjeta de Crédito',
                icon: Icons.credit_card,
                isSelected: selectedOption == 'Tarjeta de Crédito',
                onTap: () {
                  selectOption('Tarjeta de Crédito');
                  showCreditCardMessage(context);
                },
                isDarkMode: isDarkMode,
              ),
              DonationOption(
                label: 'PayPal',
                icon: Icons.account_circle,
                isSelected: selectedOption == 'PayPal',
                onTap: () {
                  selectOption('PayPal');
                  launchURL(
                      'https://paypal.me/JTorresPastor?country.x=PE&locale.x=es_XC');
                },
                isDarkMode: isDarkMode,
              ),
              DonationOption(
                label: 'Mercado Pago',
                icon: Icons.attach_money,
                isSelected: selectedOption == 'Mercado Pago',
                onTap: () {
                  selectOption('Mercado Pago');
                  launchURL('https://mpago.la/2sgeRUt');
                },
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 20.0),
              Text(
                '¡Gracias por tu apoyo!',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    print('Seleccionaste $option');
  }

  void showCreditCardMessage(BuildContext context) {
    final fakeCreditCardNumber = '**** **** **** 1234';
    final fakeBankAccount = 'Cuenta Bancaria: 1234-5678-9012-3456';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Número de Tarjeta para Donar: $fakeCreditCardNumber'),
            SizedBox(height: 8.0),
            Text(fakeBankAccount),
          ],
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void launchURL(String url) async {
    try {
      await customTabs.launch(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class DonationOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  DonationOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color? buttonColor =
        isDarkMode ? Colors.black : (isSelected ? Colors.blue[100] : null);
    Color iconColor =
        isSelected ? Colors.blue : (isDarkMode ? Colors.white : Colors.black);
    Color textColor =
        isSelected ? Colors.blue : (isDarkMode ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: buttonColor,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50.0,
                color: iconColor,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class AdminPaginaDonaciones extends StatefulWidget {
  const AdminPaginaDonaciones({Key? key}) : super(key: key);

  @override
  _AdminPaginaDonacionesState createState() => _AdminPaginaDonacionesState();
}

class _AdminPaginaDonacionesState extends State<AdminPaginaDonaciones> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Ayúdanos a crecer!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selecciona una opción de donación',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              DonationOption(
                label: 'Tarjeta de Crédito',
                icon: Icons.credit_card,
                isSelected: selectedOption == 'Tarjeta de Crédito',
                onTap: () {
                  selectOption('Tarjeta de Crédito');
                  showCreditCardMessage(context);
                },
                isDarkMode: isDarkMode,
              ),
              DonationOption(
                label: 'PayPal',
                icon: Icons.account_circle,
                isSelected: selectedOption == 'PayPal',
                onTap: () {
                  selectOption('PayPal');
                  launchURL(
                      'https://paypal.me/JTorresPastor?country.x=PE&locale.x=es_XC');
                },
                isDarkMode: isDarkMode,
              ),
              DonationOption(
                label: 'Mercado Pago',
                icon: Icons.attach_money,
                isSelected: selectedOption == 'Mercado Pago',
                onTap: () {
                  selectOption('Mercado Pago');
                  launchURL('https://mpago.la/2sgeRUt');
                },
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 20.0),
              Text(
                '¡Gracias por tu apoyo!',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    print('Seleccionaste $option');
  }

  void showCreditCardMessage(BuildContext context) {
    final fakeCreditCardNumber = '**** **** **** 1234';
    final fakeBankAccount = 'Cuenta Bancaria: 1234-5678-9012-3456';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Número de Tarjeta para Donar: $fakeCreditCardNumber'),
            SizedBox(height: 8.0),
            Text(fakeBankAccount),
          ],
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void launchURL(String url) async {
    try {
      await customTabs.launch(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class DonationOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  DonationOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    Color? buttonColor =
        isDarkMode ? Colors.black : (isSelected ? Colors.blue[100] : null);
    Color iconColor =
        isSelected ? Colors.blue : (isDarkMode ? Colors.white : Colors.black);
    Color textColor =
        isSelected ? Colors.blue : (isDarkMode ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: buttonColor,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50.0,
                color: iconColor,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
