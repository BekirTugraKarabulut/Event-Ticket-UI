
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_project/pages/cart_page.dart';

import 'package:ticket_project/services/EventService.dart';
import 'package:ticket_project/services/CartService.dart';

class AllEventTicketsPage extends StatefulWidget {
  const AllEventTicketsPage({super.key});

  @override
  State<AllEventTicketsPage> createState() =>
      _AllEventTicketsPageState();
}

class _AllEventTicketsPageState extends State<AllEventTicketsPage> {

  final EventService eventService = EventService();
  final CartService cartService = CartService();

  late Future<List<dynamic>> eventFuture;

  int selectedCategoryId = 0;

  bool isAddingToCart = false;

  final List<Map<String, dynamic>> categories = [
    {"id": 0, "name": "Tümü"},
    {"id": 1, "name": "Konser"},
    {"id": 2, "name": "Tiyatro"},
    {"id": 3, "name": "Stand-up"},
    {"id": 4, "name": "Spor"},
  ];

  @override
  void initState() {
    super.initState();
    eventFuture = eventService.getAllEvents();
  }

  void changeCategory(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;

      if (categoryId == 0) {
        eventFuture = eventService.getAllEvents();
      } else {
        eventFuture = eventService.getEventsByCategory(categoryId);
      }
    });
  }

  String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return "";
    }

    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    return "${eventService.baseUrl}$imageUrl";
  }

  Future<void> addToCart(int ticketId) async {

    if (isAddingToCart) return;

    setState(() {
      isAddingToCart = true;
    });

    try {

      final prefs = await SharedPreferences.getInstance();

      final username = prefs.getString("username");

      if (username == null || username.isEmpty) {
        throw Exception("Kullanıcı bilgisi bulunamadı!");
      }

      await cartService.addToCart(ticketId, 1);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Etkinlik sepete eklendi!"),
          backgroundColor: Colors.green,
        ),
      );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(username: username),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sepete eklenemedi: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Etkinlikler",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {

                final category = categories[index];
                final int categoryId = category["id"];

                final bool selected =
                    selectedCategoryId == categoryId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      changeCategory(categoryId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.green.shade700
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category["name"],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: eventFuture,
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Etkinlikler yüklenemedi:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final events = snapshot.data ?? [];

                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      "Bu kategoride henüz etkinlik bulunmuyor.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {

                    final event = events[index];

                    final String imageUrl =
                    getImageUrl(event["imageUrl"]?.toString());

                    final bool soldOut = event["soldOut"] == true;

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 18),
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
                            child: imageUrl.isEmpty
                                ? Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                                : Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  event["name"]?.toString() ?? "",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // TARİH
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${event["day"] ?? ""} - ${event["date"] ?? ""}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      event["time"]?.toString() ?? "",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        event["place"]?.toString() ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [

                                    Flexible(
                                      child: Text(
                                        "Kapasite: ${event["capacity"] ?? 0} Kişi",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "${event["price"] ?? 0} TL",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    Text(
                                      soldOut ? "Tükendi" : "Satışta",
                                      style: TextStyle(
                                        color: soldOut
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: soldOut || isAddingToCart
                                        ? null
                                        : () {
                                      final int ticketId =
                                      event["id"];

                                      addToCart(ticketId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.green.shade700,
                                      disabledBackgroundColor:
                                      Colors.grey,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isAddingToCart
                                        ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child:
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                        : const Text(
                                      "Bilet Al",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}
