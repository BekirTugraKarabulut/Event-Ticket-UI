
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_project/services/EventService.dart';

class EventAddPage extends StatefulWidget {
  const EventAddPage({super.key});

  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  final EventService eventService = EventService();
  final ImagePicker imagePicker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? selectedImage;

  int? selectedCategoryId;

  bool isLoading = false;

  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Konser"},
    {"id": 2, "name": "Tiyatro"},
    {"id": 3, "name": "Stand-up"},
    {"id": 4, "name": "Spor"},
  ];

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    dayController.dispose();
    timeController.dispose();
    placeController.dispose();
    capacityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      showMessage("Fotoğraf seçilemedi: $e");
    }
  }

  Future<void> addEvent() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoryId == null || selectedImage == null) {
      showMessage("Lütfen kategori ve etkinlik fotoğrafı seç.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String imageUrl =
      await eventService.uploadImage(selectedImage!.path);

      final Map<String, dynamic> eventData = {
        "id": 0,
        "categoryId": selectedCategoryId,
        "name": nameController.text.trim(),
        "date": dateController.text.trim(),
        "day": dayController.text.trim(),
        "time": timeController.text.trim(),
        "place": placeController.text.trim(),
        "imageUrl": imageUrl,
        "capacity": int.parse(capacityController.text.trim()),
        "price": double.parse(
          priceController.text.trim().replaceAll(",", "."),
        ),
        "soldOut": false,
      };

      await eventService.createEvent(eventData);

      if (!mounted) return;

      showMessage("Etkinlik başarıyla oluşturuldu!");

      formKey.currentState!.reset();

      nameController.clear();
      dateController.clear();
      dayController.clear();
      timeController.clear();
      placeController.clear();
      capacityController.clear();
      priceController.clear();

      setState(() {
        selectedImage = null;
        selectedCategoryId = null;
      });
    } catch (e) {
      if (!mounted) return;

      showMessage("Hata: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF263B38),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF35C98B),
      ),
      filled: true,
      fillColor: const Color(0xFF182321).withValues(alpha: 0.92),
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF35C98B),
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label alanı boş bırakılamaz";
        }

        if (label == "Kapasite") {
          final capacity = int.tryParse(value.trim());

          if (capacity == null || capacity <= 0) {
            return "Geçerli bir kapasite gir.";
          }
        }

        if (label == "Etkinlik Ücreti (TL)") {
          final price = double.tryParse(
            value.trim().replaceAll(",", "."),
          );

          if (price == null || price < 0) {
            return "Geçerli bir etkinlik ücreti gir.";
          }
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101816),

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Etkinlik Ekle",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF101816),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/konser.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.78),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Yeni Bir Etkinlik Oluştur",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Etkinlik bilgilerini doldur ve görselini ekle.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 25),

                  buildTextField(
                    label: "Etkinlik Adı",
                    icon: Icons.event,
                    controller: nameController,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    dropdownColor: const Color(0xFF182321),
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(
                      "Etkinlik Kategorisi",
                      Icons.category,
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category["id"] as int,
                        child: Text(category["name"] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Etkinlik Tarihi",
                    icon: Icons.calendar_month,
                    controller: dateController,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Etkinlik Günü",
                    icon: Icons.today,
                    controller: dayController,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Etkinlik Saati",
                    icon: Icons.access_time,
                    controller: timeController,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Etkinlik Yeri",
                    icon: Icons.location_on,
                    controller: placeController,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Kapasite",
                    icon: Icons.people,
                    controller: capacityController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: "Etkinlik Ücreti (TL)",
                    icon: Icons.payments,
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Etkinlik Görseli",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: selectImage,
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: const Color(0xFF182321),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF35C98B),
                          width: 1.2,
                        ),
                      ),
                      child: selectedImage == null
                          ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            color: Color(0xFF35C98B),
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Galeriden Fotoğraf Seç",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Etkinliğin kapak görselini ekle",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : addEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35C98B),
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Icon(Icons.add_circle_outline),
                      label: Text(
                        isLoading
                            ? "Etkinlik Ekleniyor..."
                            : "Etkinliği Ekle",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
