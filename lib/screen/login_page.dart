import "package:flutter/material.dart";
import "package:spark_up/common_widget/system_message.dart";
import "package:spark_up/data/profile.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/auth_path.dart";
import "package:spark_up/network/path/profile_path.dart";
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF16743), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        )
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        child: Image.asset(
                          'assets/sparkUpMainIcon.png',
                          fit: BoxFit.contain, // 根據需求選擇如何適應容器（例如 cover, contain, fill）
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                "Email",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFE9765B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              width: double.infinity,
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: const Icon(Icons.email), 
                                  prefixIconColor: Colors.black26,
                                  hintText: "Please Enter Email",
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                "Password",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFE9765B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              width: double.infinity,
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFE9765B)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: const Icon(Icons.lock), 
                                  prefixIconColor: Colors.black26,
                                  hintText: "Please Enter Password",
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: TextButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all<Size>(const Size(200, 50)),
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color(0xFFE9765B);
                          } else {
                            return Color(0xFFE9765B);
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
                            Network.manager
                                .saveUserId(response["data"]["user_id"]);
                            if (response["data"]["profile_exists"]) {
                              setState(() {
                                isLoading = true;
                              });
                              debugPrint("Sending Profile View Request");
                              final profileResponse = await Network.manager
                                  .sendRequest(
                                      method: RequestMethod.get,
                                      path: ProfilePath.view,
                                      pathMid: ["${Network.manager.userId}"]);
                              debugPrint("Finished Profile View Request");
                              debugPrint("Profile Response Status: ${profileResponse["status"]}");
                              Profile.manager = Profile.initfromData(profileResponse["data"]);

                              if(context.mounted){
                                Navigator.pushNamed(context, RouteMap.homePage);
                              }
                            } else {
                              Navigator.pushNamed(
                                  context, RouteMap.initialProfileDataPage);
                            }
                            debugPrint("Login success");
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => SystemMessage(
                                    content: response["data"]["message"]));
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
                            "Register Account",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              decoration: TextDecoration.underline
                            ),
                          )
                        ),
                      )
                    ],
                  )
                ),
              ),
            )
          ),
          if (isLoading)
            Container(
              color: Colors.black,
              child: const Opacity(
                opacity: 0.8,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            )
        ]
      )
    );
  }
}