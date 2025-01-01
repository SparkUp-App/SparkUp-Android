import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/const_variable.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/auth_path.dart';
import 'package:spark_up/route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spark_up/secure_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool isLoading = false;
  bool passwordHide = true;
  bool confirmPasswordHide = true;
  bool emailHint = false;
  bool passwordHint = false;
  bool confirmPasswordHint = false;

  Widget loginTextField(
    String textFieldIcon,
    String label,
    String hintText,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
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
          if ((label == "Email" && emailHint) ||
              (label == "Password" && passwordHint) ||
              (label == "Confirm Password" && confirmPasswordHint))
            Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                child: Text(
                  (switch (label) {
                    "Email" => "*Please enter a valid email address\n*Email length should be less than 255",
                    "Password" =>
                      "*At least 1 uppercase, 1 lowercase, 1 number\n*Letters and numbers only\n*Password length should be less than 255",
                    "Confirm Password" => "*Not match Password",
                    _ => "",
                  }),
                  style: const TextStyle(
                    fontFamily: 'IowanOldStyle',
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            width: double.infinity,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: switch (label) {
                "Password" => passwordHide,
                "Confirm Password" => confirmPasswordHide,
                _ => false,
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIconColor: Colors.black26,
                suffixIcon: switch (label) {
                  "Password" => IconButton(
                      icon: Icon(passwordHide
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          passwordHide = !passwordHide;
                        });
                      },
                    ),
                  "Confirm Password" => IconButton(
                      icon: Icon(confirmPasswordHide
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          confirmPasswordHide = !confirmPasswordHide;
                        });
                      },
                    ),
                  _ => null,
                },
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
                    fontFamily: 'IowanOldStyle', color: Colors.black38),
              ),
              onChanged: (value) {
                switch (label) {
                  case "Email":
                    emailHint = value.isEmpty || !emailRegex.hasMatch(value) || value.length > 255;
                    break;
                  case "Password":
                    passwordHint = value.isEmpty || !passwordRegex.hasMatch(value) || value.length > 255;
                    confirmPasswordHint = confirmPasswordController.text != value;
                    break;
                  case "Confirm Password":
                    confirmPasswordHint = value.isEmpty || passwordController.text != value;
                    break;
                  default:
                    break;
                }
                setState(() {});
              },
              onTapOutside: (event) => focusNode.unfocus(),
              onSubmitted: (value) {
                switch (label) {
                  case "Email":
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                    break;
                  case "Password":
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                    break;
                  case "Confirm Password":
                    FocusScope.of(context).unfocus();
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF16743), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ), //確定他是否可以scroll
                      loginTextField('assets/icons/email.svg', 'Email',
                          'Email Address', emailController, _emailFocusNode),
                      loginTextField('assets/icons/password.svg', 'Password',
                          'Password', passwordController, _passwordFocusNode),
                      loginTextField(
                          'assets/icons/password.svg',
                          'Confirm Password',
                          'Confirm Password',
                          confirmPasswordController,
                          _confirmPasswordFocusNode),
                      const SizedBox(height: 70),
                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty) {
                                emailHint = emailController.text.isEmpty;
                                passwordHint = passwordController.text.isEmpty;
                                confirmPasswordHint =
                                    confirmPasswordController.text.isEmpty;
                                showDialog(
                                    context: context,
                                    builder: (context) => const SystemMessage(
                                        title: "Register Failed",
                                        content:
                                            "Please fill in all the fields"));
                                setState(() {});
                                return;
                              }

                              if (emailHint) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const SystemMessage(
                                      title: "Register Failed",
                                      content:
                                          "Please enter a valid email address"),
                                );
                                setState(() {});
                                return;
                              }

                              if (passwordHint) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const SystemMessage(
                                      title: "Register Failed",
                                      content: "Please enter a valid password"),
                                );
                                setState(() {});
                                return;
                              }

                              if (confirmPasswordHint) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const SystemMessage(
                                      title: "Register Failed",
                                      content:
                                          "Confirm passwords do not match"),
                                );
                                setState(() {});
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              debugPrint("Sending Register Request");
                              final response =
                                  await Network.manager.sendRequest(
                                method: RequestMethod.post,
                                path: AuthPath.register,
                                data: {
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                },
                              );
                              debugPrint("Register Request Finished");

                              setState(() {
                                isLoading = false;
                              });

                              if (context.mounted) {
                                if (response["status"] == "success") {
                                  SecureStorage.store(StoreKey.userId,
                                      "${response["data"]["user_id"]}");
                                  SecureStorage.store(
                                      StoreKey.noProfile, "Yes");
                                  Network.manager
                                      .saveUserId(response["data"]["user_id"]);
                                  Profile.manager = Profile.initfromDefault();
                                  Navigator.pushReplacementNamed(
                                      context, RouteMap.initialProfileDataPage);
                                } else if (response["status"] == "error") {
                                  switch (response["data"]["message"]) {
                                    case "Timeout Error":
                                      showDialog(
                                        context: context,
                                        builder: (context) => const SystemMessage(
                                            title: "Timeout Error",
                                            content:
                                                "The response time is too long, please check the connection and try again later"),
                                      );
                                      break;
                                    case "Connection Error":
                                      showDialog(
                                        context: context,
                                        builder: (context) => const SystemMessage(
                                            title: "Connection Error",
                                            content:
                                                "The connection is not stable, please check the connection and try again later"),
                                      );
                                      break;
                                    default:
                                      showDialog(
                                          context: context,
                                          builder: (context) => const SystemMessage(
                                              title: "Register Falied",
                                              content:
                                                  "An unexpected Local error occurred. Please contact us or try again later."));
                                  }
                                } else if (response["status"] == "faild") {
                                  switch (response["status_code"]) {
                                    case 409:
                                      showDialog(
                                        context: context,
                                        builder: (context) => const SystemMessage(
                                            title: "User already exists",
                                            content:
                                                "This email address is already registered"),
                                      );
                                      break;
                                    default:
                                      showDialog(
                                          context: context,
                                          builder: (context) => const SystemMessage(
                                              title: "Register Failed",
                                              content:
                                                  "An unexpected server error occurred. Please contact us or try again later."));
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const SystemMessage(
                                        title: "Register Failed",
                                        content:
                                            "An unexpected error occurred. Please contact us or try again later."),
                                  );
                                }
                              } else {
                                return;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF16743),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Register!',
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
                  ),
                ),
              ),
            ),
          ),
          // Display loading indicator on top of the other widgets if isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.8), // Semi-transparent black
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF16743),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
