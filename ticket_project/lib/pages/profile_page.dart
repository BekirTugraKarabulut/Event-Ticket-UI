import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticket_project/services/ProfileService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final ProfileService userService = ProfileService();
  final TextEditingController username = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController surname = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    kullaniciBilgileriniGetir();
  }

  Future<void> kullaniciBilgileriniGetir() async {

    try {

      final user = await userService.getUserInfo();

      if (!mounted) return;

      setState(() {
        username.text = user.username;
        name.text = user.name;
        surname.text = user.surname;
        phoneNumber.text = user.phoneNumber;

        isLoading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil bilgileri alınamadı: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> telefonNumarasiniGuncelle() async {

    if (phoneNumber.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Telefon numarası 11 haneli olmalıdır."),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {

      final user = await userService.updatePhoneNumber(
        phoneNumber.text,
      );

      if (!mounted) return;

      setState(() {
        phoneNumber.text = user.phoneNumber;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Telefon numarası başarıyla güncellendi."),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Güncelleme başarısız: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  Widget profilTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = true,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,

          decoration: InputDecoration(
            suffixIcon: Icon(
              icon,
              color: Colors.green,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    username.dispose();
    name.dispose();
    surname.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            profilTextField(
              label: "E-posta",
              controller: username,
              icon: Icons.email,
            ),

            const SizedBox(height: 20),

            profilTextField(
              label: "Ad",
              controller: name,
              icon: Icons.person,
            ),

            const SizedBox(height: 20),

            profilTextField(
              label: "Soyad",
              controller: surname,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            profilTextField(
              label: "Telefon Numarası",
              controller: phoneNumber,
              icon: Icons.phone,
              readOnly: false,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isUpdating
                    ? null
                    : telefonNumarasiniGuncelle,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: isUpdating
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Güncelle",
                  style: TextStyle(
                    fontSize: 17,
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
