
import 'package:flutter/material.dart';
import 'package:ticket_project/services/EventService.dart';

class EventUpdateDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventUpdateDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventUpdateDetailPage> createState() =>
      _EventUpdateDetailPageState();
}

class _EventUpdateDetailPageState
    extends State<EventUpdateDetailPage> {
  final EventService eventService = EventService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController dayController;
  late TextEditingController timeController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    dayController = TextEditingController(
      text: widget.event["day"]?.toString() ?? "",
    );

    timeController = TextEditingController(
      text: widget.event["time"]?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    dayController.dispose();
    timeController.dispose();
    super.dispose();
  }

  String getImageUrl() {
    final String? imageUrl = widget.event["imageUrl"]?.toString();

    if (imageUrl == null || imageUrl.isEmpty) {
      return "";
    }

    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    return "${eventService.baseUrl}$imageUrl";
  }

  void showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> updateEvent() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final int eventId = int.parse(
        widget.event["id"].toString(),
      );

      await eventService.updateEvent(
        eventId,
        dayController.text.trim(),
        timeController.text.trim(),
      );

      if (!mounted) return;

      showMessage("Etkinlik başarıyla güncellendi!");

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      showMessage("Güncelleme başarısız: $e", error: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget infoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = getImageUrl();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Etkinlik Detayı",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl.isEmpty
                    ? Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                  ),
                )
                    : Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              Text(
                widget.event["name"]?.toString() ?? "",
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              infoRow(
                "Etkinlik Tarihi",
                widget.event["date"]?.toString() ?? "",
                Icons.calendar_month,
              ),

              infoRow(
                "Etkinlik Yeri",
                widget.event["place"]?.toString() ?? "",
                Icons.location_on,
              ),

              infoRow(
                "Kapasite",
                "${widget.event["capacity"] ?? 0} Kişi",
                Icons.people,
              ),

              infoRow(
                "Etkinlik Ücreti",
                "${widget.event["price"] ?? 0} TL",
                Icons.payments,
              ),

              const Divider(height: 30),

              const Text(
                "Gün ve Saat Bilgilerini Güncelle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: dayController,
                decoration: const InputDecoration(
                  labelText: "Etkinlik Günü",
                  prefixIcon: Icon(Icons.today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Etkinlik günü boş bırakılamaz.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Etkinlik Saati",
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Etkinlik saati boş bırakılamaz.";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : updateEvent,
                  icon: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(
                    isLoading ? "Güncelleniyor..." : "Değişiklikleri Kaydet",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
