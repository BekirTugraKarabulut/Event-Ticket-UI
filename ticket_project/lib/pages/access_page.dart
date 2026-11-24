
import 'package:flutter/material.dart';
import 'package:ticket_project/services/PurchasedService.dart';

class AccessPage extends StatefulWidget {

  final int purchaseId;

  const AccessPage({
    super.key,
    required this.purchaseId,
  });

  @override
  State<AccessPage> createState() => _AccessPageState();
}

class _AccessPageState extends State<AccessPage> {

  final PurchasedService purchasedService = PurchasedService();

  late Future<String> accessCodeFuture;

  @override
  void initState() {
    super.initState();

    accessCodeFuture = purchasedService.getAccessCodeByPurchasedId(
      widget.purchaseId,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Bilet Giriş Kodu",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Center(
        child: FutureBuilder<String>(
          future: accessCodeFuture,

          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.green,
              );
            }

            if (snapshot.hasError) {
              return const Text(
                "Giriş kodu alınamadı.",
                style: TextStyle(color: Colors.red),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Giriş kodu bulunamadı.");
            }

            return Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/qr.jpg"),
                  const SizedBox(height: 25),
                  const Text(
                    "Etkinlik Giriş Kodunuz",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),

                    child: SelectableText(
                      snapshot.data!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Etkinlik girişinde bu kodu görevlilere gösteriniz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
