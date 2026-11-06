
import 'package:flutter/material.dart';

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
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Hoş Geldiniz, ${widget.username}!" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 20),),
                  ],
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Yakın Tarihtekiler" , style: TextStyle(color: Colors.white  , fontSize: 25),),
                  ],
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 80),
                Column(
                  children: [
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.green
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                    Radius.circular(10)
                                )
                            ),
                          )
                      ),onPressed: () {

                      }, child: const Text("🎟️ Etkinlikleri Keşfet",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 18),),),
                    ),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 155,
                          height: 50,
                          child: ElevatedButton(style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Colors.green
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(10)
                                    )
                                ),
                              )
                          ),onPressed: () {

                          }, child: const Text("✅ Biletlerim",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),)),
                        ),
                        Container(
                          width: 155,
                          height: 50,
                          child: ElevatedButton(style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Colors.green
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(10)
                                    )
                                ),
                              )
                          ),onPressed: () {

                          }, child: const Text("👤 Profilim",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 50,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10 , right: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Hızlı Kategoriler",style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                          GestureDetector(
                              onTap: () {

                              },
                              child: Text("Tümünü Gör →",style: TextStyle(color: Colors.greenAccent , fontWeight: FontWeight.bold)))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10)
                            )
                          ),
                          child: Column(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.all(
                                Radius.circular(20)
                              ),
                                child: Image.asset("images/concer.jpg",
                                height: 120,
                                width: 120,
                                  fit: BoxFit.cover,),
                              ),
                              Text("Konser",style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                              )
                          ),
                          child: Column(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                                child: Image.asset("images/theatre.jpg",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,),
                              ),
                              Text("Tiyatro",style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                              )
                          ),
                          child: Column(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                              ),
                                child: Image.asset("images/standup.jpg",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,),
                              ),
                              Text("Stand-up",style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                Text("© 2026 Şubilet Tüm Hakları Saklıdır.", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
