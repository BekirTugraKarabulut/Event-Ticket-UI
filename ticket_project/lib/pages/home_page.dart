import 'package:flutter/material.dart';
import 'package:ticket_project/pages/all_event_tickets_page.dart';
import 'package:ticket_project/pages/cart_page.dart';
import 'package:ticket_project/pages/login_page.dart';
import 'package:ticket_project/pages/my_purchases_page.dart';
import 'package:ticket_project/pages/profile_page.dart';
import 'package:ticket_project/services/UserService.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PageController pageController = PageController(
    viewportFraction: 0.65,
  );

  final Userservice userService = Userservice();

  Future<String>? nameFuture;

  final List<String> resimler = [
    "images/cok-guzel-hareketler-2.jpeg",
    "images/dogu-demirkol.jpeg",
    "images/emir-can-igrek.jpeg",
    "images/gokhan-ozen-live-in-concert.jpeg",
    "images/christmas-town-izmir-festival-bazaar.jpeg",
  ];

  double aktifSayfa = 0;

  @override
  void initState() {
    super.initState();

    print("Flutter username: ${widget.username}");
    nameFuture = userService.getNameByUsername(widget.username);

    pageController.addListener(() {
      setState(() {
        aktifSayfa = pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "images/konser.jpeg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withValues(alpha: 0.25),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: FutureBuilder<String>(
                          future: nameFuture,
                          builder: (context, snapshot) {

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                "Hoş Geldiniz!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return const Text(
                                "Hoş Geldiniz!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              );
                            }

                            return Text(
                              "Hoş Geldiniz , ${snapshot.data}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CartPage(username: widget.username)));
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                                (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Çıkış yapıldı.",style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.green,
                            )
                          );

                        },
                        icon: const Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  height: 2,
                  indent: 10,
                  endIndent: 10,
                ),

                const SizedBox(height: 50),

                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: resimler.length,
                    itemBuilder: (context, index) {

                      double fark =
                      (aktifSayfa - index).abs();

                      double scale =
                      (1 - (fark * 0.25)).clamp(0.75, 1.0);

                      double opacity =
                      (1 - (fark * 0.55)).clamp(0.35, 1.0);

                      return Center(
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  resimler[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(Colors.green),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const AllEventTicketsPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Etkinlikleri Keşfet",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        SizedBox(
                          width: 155,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              const WidgetStatePropertyAll(Colors.green),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPurchasesPage()));
                            },
                            child: const Text(
                              "Biletlerim",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 155,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              const WidgetStatePropertyAll(Colors.green),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    )
                                    ,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                            },
                            child: const Text(
                              "Profilim",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Column(
                  children: [

                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 50,
                      indent: 10,
                      endIndent: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Hızlı Kategoriler",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AllEventTicketsPage()));
                            },
                            child: const Text(
                              "Tümünü Gör →",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/concer.jpg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text(
                              "Konser",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/theatre.jpg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text(
                              "Tiyatro",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "images/standup.jpg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text(
                              "Stand-up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 70),

                const Text(
                  "© 2026 Tüm Hakları Saklıdır.",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
