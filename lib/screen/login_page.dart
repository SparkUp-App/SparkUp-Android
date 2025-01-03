import "package:flutter/material.dart";
import "package:spark_up/chat/chat_room_manager.dart";
import "package:spark_up/common_widget/exit_dialog.dart";
import "package:spark_up/common_widget/system_message.dart";
import "package:spark_up/const_variable.dart";
import "package:spark_up/data/profile.dart";
import "package:spark_up/network/network.dart";
import "package:spark_up/network/path/auth_path.dart";
import "package:spark_up/notificatoin_manager.dart";
import "package:spark_up/route.dart";
import 'package:flutter_svg/flutter_svg.dart';
import "package:spark_up/secure_storage.dart";
import "package:spark_up/socket_service.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwrordFocusNode = FocusNode();
  bool passwordHide = true;
  bool emailEmpty = false;
  bool passwordEmpty = false;

  Widget loginTextField(String textFieldIcon, String label, String hintText,
      TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              if ((label == "Email" && emailEmpty) ||
                  (label == "Password" && passwordEmpty))
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  child: Text(
                      label == "Email"
                          ? "*Email cannot be empty"
                          : "*Password cannot be empty",
                      style: const TextStyle(
                        fontFamily: 'IowanOldStyle',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      )),
                )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            width: double.infinity,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autocorrect: false,
              obscureText: label == "Email" ? false : passwordHide,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: label == "Password"
                    ? IconButton(
                        icon: Icon(
                          passwordHide
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordHide = !passwordHide;
                          });
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE9765B)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(
                    textFieldIcon,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
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
              onTapOutside: (tap) {
                focusNode.unfocus();
              },
              onSubmitted: (value) {
                label == "Email"
                    ? FocusScope.of(context).requestFocus(_passwrordFocusNode)
                    : FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  label == "Email" ? emailEmpty = true : passwordEmpty = true;
                } else {
                  label == "Email" ? emailEmpty = false : passwordEmpty = false;
                }
                setState(() {});
              },
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
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.7,
                                child: Image.asset(
                                  'assets/sparkUpMainIcon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              loginTextField(
                                  'assets/icons/email.svg',
                                  'Email',
                                  'Email Address',
                                  emailController,
                                  _emailFocusNode),
                              loginTextField(
                                  'assets/icons/password.svg',
                                  'Password',
                                  'Password',
                                  passwordController,
                                  _passwrordFocusNode),
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
                                      if (emailController.text.length > 255) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const SystemMessage(
                                                    title: "Login Failed",
                                                    content:
                                                        "Input email address is not legal."));
                                        setState(() {});
                                        return;
                                      }

                                      if (passwordController.text.length >
                                          255) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const SystemMessage(
                                                    title: "Login Failed",
                                                    content:
                                                        "Input password is not legal."));
                                        setState(() {});
                                        return;
                                      }

                                      if (emailController.text.isEmpty) {
                                        emailEmpty = true;
                                      }
                                      if (passwordController.text.isEmpty) {
                                        passwordEmpty = true;
                                      }
                                      if (passwordEmpty || emailEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const SystemMessage(
                                                    title: "Login Failed",
                                                    content:
                                                        "Please fill in all fields"));
                                        setState(() {});
                                        return;
                                      }

                                      if (!emailRegex
                                          .hasMatch(emailController.text)) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const SystemMessage(
                                                    title: "Login Failed",
                                                    content:
                                                        "Please enter a valid email address"));
                                        setState(() {});
                                        return;
                                      }

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
                                          NotificationManager.init();
                                          SecureStorage.store(StoreKey.userId,
                                              "${response["data"]["user_id"]}");
                                          Network.manager.saveUserId(
                                              response["data"]["user_id"]);
                                          if (response["data"]
                                              ["profile_exists"]) {
                                            SocketService.manager.initSocket(
                                                userId: Network.manager.userId!,
                                                onMessage: ChatRoomManager
                                                    .manager
                                                    .socketMessageCallback,
                                                onApprovedMessage:
                                                    ChatRoomManager.manager
                                                        .socketApproveCallback,
                                                onRejectedMessage:
                                                    ChatRoomManager.manager
                                                        .socketRejectedCallback,
                                                onApplyMessage: ChatRoomManager
                                                    .manager
                                                    .socketApplyCallback);
                                            ChatRoomManager.manager.getData();
                                            SecureStorage.store(
                                                StoreKey.noProfile, "No");
                                            Navigator.pushReplacementNamed(
                                                context, RouteMap.homePage);
                                          } else {
                                            SecureStorage.store(
                                                StoreKey.noProfile, "Yes");
                                            Profile.manager =
                                                Profile.initfromDefault();
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteMap
                                                    .initialProfileDataPage);
                                          }
                                          debugPrint("Login success");
                                        } else if(response["status"] == "error"){
                                          switch (response["data"]["message"]){
                                            case "Timeout Error":
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed", content: "The response time is too long, pleas check the connection and try again later."));
                                              break;
                                            case "Connection Error":
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed", content: "The connection is unstable, please check the connection and try again later."));
                                              break;
                                            default:
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed", content: "An unexpected local error occured, please contact us or try again later."));
                                              break;
                                          }
                                        } else if (response["status"] == "faild"){
                                          switch (response["status_code"]){
                                            case 401:
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed", content: "No user found.\nPlease check the email and password."));
                                              break;
                                            case 400:
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed", content: "No user found. \nPlease check the email and password."));
                                              break;
                                            default:
                                              showDialog(context: context, builder: (context) => const SystemMessage(title: "Login Failed",content: "An unexpected server error occured, please contact us or try again later."));
                                              break;
                                          }
                                        }
                                        else {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const SystemMessage(
                                                      title: "Login Failed",
                                                      content:
                                                          "An unexpected error occured, please contact us or try again later."));
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
                        child: CircularProgressIndicator(
                          color: Color(0xFFF16743),
                        ),
                      ),
                    ))
            ])));
  }
}
