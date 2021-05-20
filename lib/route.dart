import 'package:bussiness_web_app/ui/pages/about/about.dart';
import 'package:bussiness_web_app/ui/pages/about/product.dart';
import 'package:bussiness_web_app/ui/pages/about/profile.dart';
import 'package:bussiness_web_app/ui/pages/agent/schedule.dart';
import 'package:bussiness_web_app/ui/pages/home/agent_home.dart';
import 'package:bussiness_web_app/ui/pages/home/delivery_home.dart';
import 'package:bussiness_web_app/ui/pages/orders/new_order.dart';
import 'package:bussiness_web_app/ui/pages/property/list_property.dart';
import 'package:bussiness_web_app/ui/pages/user/userList.dart';
import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/auth_repository.dart';

import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/ui/pages/login/login_page.dart';

final routes = {
  '/login': (BuildContext context) => LoginPage(
        authRepository: AuthRepository(),
      ),
  '/home': (BuildContext context) => HomePage(),
  '/product1': (BuildContext context) => ProductPage(),
  '/agent_home': (BuildContext context) => AgentHomePage(),
  '/product_list': (BuildContext context) => PropertyListPage(),
  '/schedule_list': (BuildContext context) => ListSchedulePage(),
  '/about_page': (BuildContext context) => AboutPage(),
  '/delivery_home': (BuildContext context) => DeliveryHomePage(),
  '/orders': (BuildContext context) => NewOrderPage(),
  '/new_user': (BuildContext context) => NewUserPage(),
  '/profile': (BuildContext context) => ProfilePage(),
};
