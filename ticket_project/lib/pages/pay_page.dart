
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_project/pages/success_page.dart';

class PayPage extends StatefulWidget {

  final String username;
  const PayPage({super.key, required this.username});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  final TextEditingController creditCartNumber = TextEditingController();
  final TextEditingController mmdd = TextEditingController();
  final TextEditingController cvv = TextEditingController();

  bool isLoading = false;

  Future<void> satinAl() async {

    if (creditCartNumber.text.replaceAll(' ', '').length != 16 ||
        mmdd.text.length != 5 ||
        cvv.text.length != 3) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen kart bilgilerini eksiksiz girin."),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? token = prefs.getString("accessToken");

      if (token == null) {
        throw Exception("Oturum bilgisi bulunamadı.");
      }

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8085/credit/pay"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "creditCartNumber":
          creditCartNumber.text.replaceAll(' ', ''),
          "mmdd": mmdd.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(username: widget.username),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Satın alma başarısız: ${response.statusCode}\n${response.body}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bir hata oluştu: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    creditCartNumber.dispose();
    mmdd.dispose();
    cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ödeme"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Center(
              child: Icon(
                Icons.credit_card,
                size: 75,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Kart Numarası",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: creditCartNumber,
              keyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: "1234567890123456",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
                counterText: "",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Son Kullanma Tarihi (AA/YY)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: mmdd,
              keyboardType: TextInputType.number,
              maxLength: 5,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction(
                      (oldValue, newValue) {

                    String sayilar =
                    newValue.text.replaceAll("/", "");

                    if (sayilar.length > 4) {
                      sayilar = sayilar.substring(0, 4);
                    }

                    String sonuc = sayilar;

                    if (sayilar.length > 2) {
                      sonuc =
                      "${sayilar.substring(0, 2)}/${sayilar.substring(2)}";
                    }

                    return TextEditingValue(
                      text: sonuc,
                      selection: TextSelection.collapsed(
                        offset: sonuc.length,
                      ),
                    );
                  },
                ),
              ],
              decoration: const InputDecoration(
                hintText: "AA/YY",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_month),
                counterText: "",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "CVV",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: cvv,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 3,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: "123",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                counterText: "",
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isLoading ? null : satinAl,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),

                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Satın Al",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
