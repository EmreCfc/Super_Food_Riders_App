import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(  //farklı iki renkte,boyutlandırılabilen app bar oluşturur.
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.cyan,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text("Super Food",
          style: TextStyle(
            fontSize: 60,
            color: Colors.white,
            fontFamily: "Signatra",
            letterSpacing: 6              //fontun nereden çekileceğinin yazıldığı yer.
          ),
          ),
          centerTitle: true,
          bottom: const TabBar(tabs: [    //Appbarın altında ki login ve register için bitişik bar oluşturur.
            Tab(
              icon: Icon(Icons.lock,color: Colors.white,),
              text: "Login",
            ),
            Tab(
              icon: Icon(Icons.person,color: Colors.white,),
              text: "Register",
            ),
          ],
            indicatorColor: Colors.white38, //Loıgin ve Register altında ki barın rengini değiştirir.
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration( //appbar altındaki geri kalan box'un başlangıç ve bitiş noktasıyla rengini ayarlama.
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
