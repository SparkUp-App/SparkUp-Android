import 'package:flutter/material.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
                                WidgetStateProperty.resolveWith<Color>(
                                    (states) {
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
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Container(
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: const Text("System Message")),
                                      content: Container(
                                        height: 40.0,
                                        alignment: Alignment.center,
                                        child: Text(response["data"]["message"]),
                                      ),
                                      actions: [
                                        Container(
                                          height: 40.0,
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                              onPressed: (){
                                                  if(response["status"] == "success"){
                                                    Network.manager.saveUserToken(response["data"]["user_id"]);
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(context, RouteMap.homePage);
                                                  } else{
                                                    Navigator.pop(context);
                                                  }
                                              },
                                              child: const Text("OK")),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          child: const Text(
                            "Regist",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                )),
            if (isLoading)
              Opacity(
                  opacity: 0.8,
                  child: Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator())))
          ],
        )));
  }
}
