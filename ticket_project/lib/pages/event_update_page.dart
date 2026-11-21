
import 'package:flutter/material.dart';
import 'package:ticket_project/services/EventService.dart';
import 'event_update_details_page.dart';

class EventUpdatePage extends StatefulWidget {
  const EventUpdatePage({super.key});

  @override
  State<EventUpdatePage> createState() => _EventUpdatePageState();
}

class _EventUpdatePageState extends State<EventUpdatePage> {
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

  String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return "";
    }

    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    return "${eventService.baseUrl}$imageUrl";
  }

  Future<void> openUpdatePage(Map<String, dynamic> event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventUpdateDetailPage(event: event),
      ),
    );

    if (result == true) {
      refreshEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Etkinlik Güncelle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              child: Text("Henüz etkinlik bulunmuyor."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> event =
              Map<String, dynamic>.from(events[index]);

              final String imageUrl =
              getImageUrl(event["imageUrl"]?.toString());

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
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
                        height: 160,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 45,
                        ),
                      )
                          : Image.network(
                        imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 45,
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event["name"]?.toString() ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${event["day"] ?? ""} - ${event["date"] ?? ""}",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(event["time"]?.toString() ?? ""),
                            ],
                          ),

                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event["place"]?.toString() ?? "",
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
                                openUpdatePage(event);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text(
                                "Güncelle",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
