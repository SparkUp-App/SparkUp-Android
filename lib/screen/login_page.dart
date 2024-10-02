import "package:flutter/material.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/auth_path.dart";
import "package:spark_up/route.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          body: Center(
        child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
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
                        setState(() {
                          isLoading = true;
                        });

                        debugPrint("Sending Login Request");
                        dynamic response = await Network.manager.sendRequest(
                            method: RequestMethod.post,
                            path: AuthPath.login,
                            data: {
                              "email": emailController.text,
                              "password": passwordController.text,
                            });
                        debugPrint("Login Request Finished");

                        setState(() {
                          isLoading = false;
                        });

                        if (context.mounted) {
                          debugPrint("${response["status"]}");
                          if (response["status"] == "success") {
                            Network.manager.saveUserToken(response["data"]["user_id"]);
                            Navigator.pushNamed(context, RouteMap.homePage);
                            debugPrint("Login success");
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Container(
                                      alignment: Alignment.center,
                                      height: 40.0,
                                      child: const Text("System Message"),
                                    ),
                                    content: Container(
                                      alignment: Alignment.center,
                                      height: 40.0,
                                      child: Text(response["data"]["message"]),
                                    ),
                                    actions: [
                                      Container(
                                          alignment: Alignment.centerRight,
                                          height: 40.0,
                                          child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("OK")))
                                    ],
                                  );
                                });
                          }
                        }
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
      )),
      if (isLoading)
        Container(
            color: Colors.black,
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ))
    ]);
  }
}
