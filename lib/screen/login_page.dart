import "package:flutter/material.dart";
import "package:spark_up/route.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Please Enter Email",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        )),
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Please Enter Password",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        )),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color.fromARGB(255, 216, 59, 48);
                        } else {
                          return Colors.red;
                        }
                      }),
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                child: const Text("Information"),
                              ),
                              content: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                child: const Text(
                                    "Welcome to Spark UP!!\ncomming soon~"),
                              ),
                              actions: [
                                Container(
                                    alignment: Alignment.centerRight,
                                    height: 40.0,
                                    child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK")))
                              ],
                            );
                          });
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteMap.registerPage);
                    },
                    child: const Text(
                      "Regist Account",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline),
                    )),
              )
            ],
          )),
    ));
  }
}
