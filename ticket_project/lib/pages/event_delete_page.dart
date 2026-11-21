
import 'package:flutter/material.dart';
import 'package:ticket_project/services/EventService.dart';

class EventDeletePage extends StatefulWidget {
  const EventDeletePage({super.key});

  @override
  State<EventDeletePage> createState() => _EventDeletePageState();
}

class _EventDeletePageState extends State<EventDeletePage> {
  final EventService eventService = EventService();

  late Future<List<dynamic>> eventFuture;

  @override
  void initState() {
    super.initState();
    eventFuture = eventService.getAllEvents();
  }

  void refreshEvents() {
    setState(() {
      eventFuture = eventService.getAllEvents();
    });
  }

  String getImageUrl(dynamic imageUrl) {
    if (imageUrl == null || imageUrl.toString().isEmpty) {
      return "";
    }

    final String path = imageUrl.toString();

    if (path.startsWith("http")) {
      return path;
    }

    return "http://10.0.2.2:8082$path";
  }

  Future<void> confirmDelete(Map<String, dynamic> event) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Etkinliği Sil",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '"${event["name"]}" etkinliğini silmek istediğine emin misin?',
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Vazgeç",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text("Sil"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteEvent(event);
    }
  }

  Future<void> deleteEvent(Map<String, dynamic> event) async {
    try {
      final int eventId = int.parse(event["id"].toString());

      await eventService.deleteEvent(eventId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Etkinlik başarıyla silindi!"),
          backgroundColor: Colors.green,
        ),
      );

      refreshEvents();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Etkinlik silinemedi: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Etkinlik Sil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: eventFuture,
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
                "Etkinlikler yüklenemedi: ${snapshot.error}",
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                "Henüz etkinlik bulunmuyor.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> event =
              Map<String, dynamic>.from(events[index]);

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 180,
                          child: getImageUrl(event["imageUrl"]).isNotEmpty
                              ? Image.network(
                            getImageUrl(event["imageUrl"]),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        event["name"]?.toString() ?? "İsimsiz Etkinlik",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${event["day"] ?? ""} - ${event["date"] ?? ""}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event["time"]?.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event["place"]?.toString() ?? "",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            confirmDelete(event);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text(
                            "Etkinliği Sil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
