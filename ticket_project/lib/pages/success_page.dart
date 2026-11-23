
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ticket_project/pages/home_page.dart';

class SuccessPage extends StatefulWidget {

  final String username;
  const new({super.key, required this.username});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: widget.username),
        ),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 110,
              ),

              const SizedBox(height: 25),

              const Text(
                "Ödeme Başarılı!",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Satın alma işleminiz başarıyla tamamlandı.\n"
                    "Biletleriniz hesabınıza eklendi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 35),

              const CircularProgressIndicator(
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              const Text(
                "Ana sayfaya yönlendiriliyorsunuz...",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
