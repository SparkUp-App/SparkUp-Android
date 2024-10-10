import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/system_message.dart';
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

  Widget login_TextField(IconData textFieldIcon,String label,String hintText,TextEditingController controller,{isObscured=false}) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
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
              obscureText: isObscured, //確認是否要點點隱藏輸入的內容
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF16743), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.center,
            )
        ),
        child:Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Stack(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            login_TextField(Icons.email,'Email','Email Address',emailController),
                            login_TextField(Icons.lock,'Password','Password',passwordController,isObscured: true),
                            login_TextField(Icons.lock,'Confirm Password','Confirm Password',confirmPasswordController,isObscured: true),
                            SizedBox(height: 70),
                            Center(
                              child: SizedBox( //SizedBox鎖他大小
                                width: 220,
                                height: 47,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (passwordController.text != confirmPasswordController.text) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Passwords do not match!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });

                                    debugPrint("Sending Regist Request");
                                    final response = await Network.manager.sendRequest(
                                        method: RequestMethod.post,
                                        path: AuthPath.register,
                                        data: {
                                          "email": emailController.text,
                                          "password": passwordController.text,
                                        });
                                    debugPrint("Regitst Request Finish");

                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (context.mounted) {
                                      if (response["status"] == "success") {
                                        Network.manager.saveUserId(response["data"]["user_id"]);
                                        Navigator.pushNamed(context, RouteMap.initialProfileDataPage);
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
                        )),
                    if (isLoading)
                      Opacity(
                          opacity: 0.8,
                          child: Container(
                              color: Colors.black,
                              child: const Center(child: CircularProgressIndicator())))
                  ],
                )
            )
        )
    );
  }
}
