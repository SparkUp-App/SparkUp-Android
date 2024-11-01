import "package:flutter/material.dart";
import "package:spark_up/common_widget/exit_dialog.dart";
import "package:spark_up/common_widget/system_message.dart";
import "package:spark_up/data/profile.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/auth_path.dart";
import "package:spark_up/network/path/profile_path.dart";
import "package:spark_up/route.dart";
import 'package:flutter_svg/flutter_svg.dart';
import "package:spark_up/common_widget/exit_dialog.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  Widget loginTextField(String textFieldIcon, String label, String hintText,
      TextEditingController controller,
      {isObscured = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
            child: Text(
              label,
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
              controller: controller,
              obscureText: isObscured, //確認是否要用點點隱藏輸入的內容(密碼欄位最需要)
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE9765B)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    textFieldIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                prefixIconColor: Colors.black26,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'IowanOldStyle',
                  color: Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          await showDialog(
            context: context,
            builder: (context) => const ExitConfirmationDialog(),
          );
        },
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xFFF16743), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.center,
            )),
            child: Stack(children: [
              Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(), //物理動畫
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 273,
                                height: 273,
                                child: Image.asset(
                                  'assets/sparkUpMainIcon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              loginTextField('assets/icons/email.svg', 'Email',
                                  'Email Address', emailController),
                              loginTextField('assets/icons/password.svg',
                                  'Password', 'Password', passwordController,
                                  isObscured: true),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: SizedBox(
                                  //SizedBox鎖他大小
                                  width: 220,
                                  height: 47,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      debugPrint("Sending Login Request");
                                      dynamic response = await Network.manager
                                          .sendRequest(
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
                                          Network.manager.saveUserId(
                                              response["data"]["user_id"]);
                                          if (response["data"]
                                              ["profile_exists"]) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            debugPrint(
                                                "Sending Profile View Request");
                                            final profileResponse =
                                                await Network.manager
                                                    .sendRequest(
                                                        method:
                                                            RequestMethod.get,
                                                        path: ProfilePath.view,
                                                        pathMid: [
                                                  "${Network.manager.userId}"
                                                ]);
                                            debugPrint(
                                                "Finished Profile View Request");
                                            debugPrint(
                                                "Profile Response Status: ${profileResponse["status"]}");
                                            Profile.manager =
                                                Profile.initfromData(
                                                    profileResponse["data"]);

                                            if (context.mounted) {
                                              Navigator.pushReplacementNamed(
                                                  context, RouteMap.homePage);
                                            }
                                          } else {
                                            Profile.manager =
                                                Profile.initfromDefault();
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteMap
                                                    .initialProfileDataPage);
                                          }
                                          debugPrint("Login success");
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SystemMessage(
                                                      content: response["data"]
                                                          ["message"]));
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF16743),
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
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: SizedBox(
                                  // SizedBox 控制大小
                                  width: 220,
                                  height: 47,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteMap.registerPage);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF16743),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign Up',
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
                            ],
                          )),
                    ),
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
            ])));
  }
}
