import "package:flutter/material.dart";
import "package:spark_up/screen/login_page.dart";
import "package:spark_up/screen/register_page.dart";
import "package:spark_up/screen/home_page.dart";
class RouteMap{
  //Regist Path for page
  static const loginPage = "/loginPage";
  static const registerPage = "/registerPage";
  static const homePage = "/homePage";
  //Bind page to Path
  static Map<String, WidgetBuilder> routes = {
    loginPage : (context) => const LoginPage(),
    registerPage : (context) => const RegisterPage(),
    homePage : (context) => const HomePage(),
  };
}