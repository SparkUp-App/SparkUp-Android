import 'package:flutter/material.dart';
import 'package:spark_up/common_widget/exit_dialog.dart';
import 'package:spark_up/route.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.fromSetting});

  final bool fromSetting;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int currentStep = 0;
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    images = [
      Image.asset('assets/tutorial/1.png', fit: BoxFit.contain),
      Image.asset('assets/tutorial/2.png', fit: BoxFit.contain),
      Image.asset('assets/tutorial/3.png', fit: BoxFit.contain),
      Image.asset('assets/tutorial/4.png', fit: BoxFit.contain),
      Image.asset('assets/tutorial/5.png', fit: BoxFit.contain),
    ];
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
                    child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Image.asset(
                                'assets/sparkUpMainIcon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  for (int i = images.length - 1;
                                      i >= currentStep;
                                      i--)
                                    Center(
                                      child: images[i],
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: currentStep > 0
                                      ? TextButton(
                                          style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              currentStep--;
                                            });
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFD9464),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned(
                                                    left: 0.0,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_back_ios_rounded,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Back",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )))
                                      : TextButton(
                                          style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                          ),
                                          onPressed: () {
                                            widget.fromSetting
                                                ? Navigator.pop(context)
                                                : Navigator.pushNamed(
                                                    context, RouteMap.homePage);
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF827C79),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "Skip",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                ),
                                Center(
                                  child: currentStep < 4
                                      ? TextButton(
                                          style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              currentStep++;
                                            });
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5.0),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF5F8E9F),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "Next",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 0,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )))
                                      : TextButton(
                                          style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                          ),
                                          onPressed: () {
                                            widget.fromSetting
                                                ? Navigator.pop(context)
                                                : Navigator.pushNamed(
                                                    context, RouteMap.homePage);
                                          },
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5.0),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF5F8E9F),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    "Got it!",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                ),
                              ],
                            ),
                          ],
                        )),
                  )),
            ])));
  }
}
