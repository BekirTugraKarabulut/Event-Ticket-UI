import 'package:flutter/material.dart';
import 'package:ticket_project/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  var usernameController = TextEditingController();
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("images/konser.jpeg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180 , right: 20 , left: 20),
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.green,
                    style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                    controller: usernameController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.email , color: Colors.green,),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.green,
                    style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                    controller: nameController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person , color: Colors.green,),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "İsim",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.green,
                    style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                    controller: surnameController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person , color: Colors.green,),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Soyisim",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.green,
                    style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.lock , color: Colors.green,),
                      hintText: "Şifre",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.green
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(10)
                          )
                        )
                      )
                    )
                    ,onPressed: () {

                    }, child: Text("Kayıt Ol" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 16),)),
                  ),
                  const SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Zaten bir hesabım var ? " , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize: 16),),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: Text("Giriş Yap" ,
                            style: TextStyle(color: Colors.green , fontSize: 16 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline),))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
