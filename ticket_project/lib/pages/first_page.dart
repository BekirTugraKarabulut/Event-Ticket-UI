import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ticket_project/pages/register_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  Future<void> _loadAnimation() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/validating-ticket-pinch.json' , height: 200 , width: 200),
          ],
        ),
      ),
    );
  }
}
