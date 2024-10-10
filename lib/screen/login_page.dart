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
                          margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 273,
                                height: 273,
                                child: Image.asset(
                                  'assets/sparkUpMainIcon.png',
                                  fit: BoxFit.contain, // 根據需求選擇如何適應容器（例如 cover, contain, fill）
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        "Email",
                                        style: const TextStyle(
                                          fontFamily: 'IowanOldStyle',
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
                                          hintText: "Email Address",
                                          hintStyle: const TextStyle(
                                            fontFamily: 'IowanOldStyle',
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        "Password",
                                        style: const TextStyle(
                                          fontFamily: 'IowanOldStyle',
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
                                            fontFamily: 'IowanOldStyle',
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              
                              Center( 
                                child: SizedBox( //SizedBox鎖他大小
                                  width: 220, 
                                  height: 47,
                                  child: ElevatedButton(
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFF16743),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'IowanOldStyle',
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: SizedBox( // SizedBox 控制按鈕大小
                                  width: 220,
                                  height: 47,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, RouteMap.registerPage);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFF16743),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign Up', // 改為 'Register' 因為這個按鈕是用來註冊的
                                      style: TextStyle(
                                        fontFamily: 'IowanOldStyle',
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                        fontFamily: 'IowanOldStyle',
                                        color: Color(0xFFF16743),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
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