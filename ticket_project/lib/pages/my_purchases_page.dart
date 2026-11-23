
import 'package:flutter/material.dart';
import 'package:ticket_project/services/PurchasedService.dart';

class MyPurchasesPage extends StatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  State<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {

  final PurchasedService purchasedService = PurchasedService();

  late Future<List<dynamic>> purchasesFuture;

  @override
  void initState() {
    super.initState();
    purchasesFuture = purchasedService.getMyPurchases();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Biletlerim",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: FutureBuilder<List<dynamic>>(
        future: purchasesFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Biletler yüklenirken hata oluştu:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Henüz satın aldığınız bir bilet bulunmuyor.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            );
          }

          final purchases = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: purchases.length,

            itemBuilder: (context, index) {

              final purchase = purchases[index];

              final String imageUrl =
                  purchase["imageUrl"] ?? "";

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 18),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                        "http://10.0.2.2:8082$imageUrl",
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                            ),
                          );
                        },
                      )
                          : Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.event,
                          size: 50,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            purchase["name"] ?? "Etkinlik",
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _bilgiSatiri(
                            Icons.calendar_month,
                            "${purchase["date"]} - ${purchase["day"]}",
                          ),

                          _bilgiSatiri(
                            Icons.location_on,
                            purchase["place"] ?? "",
                          ),

                          _bilgiSatiri(
                            Icons.access_time,
                            purchase["time"] ?? "",
                          ),

                          _bilgiSatiri(
                            Icons.confirmation_number,
                            "${purchase["quantity"]} adet bilet",
                          ),

                          _bilgiSatiri(
                            Icons.payments,
                            "${purchase["price"]} TL",
                          ),

                          const Divider(height: 25),

                          Container(
                            width: 600,
                            height: 50,
                            child: ElevatedButton(style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.green
                              ),
                              side: WidgetStatePropertyAll(
                                BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                )
                              )
                            ),onPressed: (){

                            }, child: Text("QR Giriş" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18),)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _bilgiSatiri(IconData icon, String bilgi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              bilgi,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
