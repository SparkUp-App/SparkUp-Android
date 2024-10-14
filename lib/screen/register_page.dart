import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
import 'package:spark_up/data/profile.dart';
import 'package:spark_up/network/network.dart';
import 'package:spark_up/network/path/auth_path.dart';
import 'package:spark_up/route.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Widget loginTextField(IconData textFieldIcon, String label, String hintText,
      TextEditingController controller,
      {bool isObscured = false}) {
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
              obscureText: isObscured,
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
                prefixIcon: Icon(textFieldIcon),
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
                icon: const Icon(Icons.arrow_back, size: 30.0,),
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
                      loginTextField(Icons.email, 'Email', 'Email Address',
                          emailController),
                      loginTextField(Icons.lock, 'Password', 'Password',
                          passwordController,
                          isObscured: true),
                      loginTextField(Icons.lock, 'Confirm Password',
                          'Confirm Password', confirmPasswordController,
                          isObscured: true),
                      const SizedBox(height: 70),
                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                showDialog(
                                  //這裡我先多check密碼與確認密碼是否匹配
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text('Passwords do not match!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
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
                                  Network.manager
                                      .saveUserId(response["data"]["user_id"]);
                                  Profile.manager = Profile.initfromDefault();
                                  Navigator.pushReplacementNamed(
                                      context, RouteMap.initialProfileDataPage);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => SystemMessage(
                                        content: response["data"]["message"]),
                                  );
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
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
