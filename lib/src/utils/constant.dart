import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Constant{
  // routes
  static const String HOME_ROUTE = '/home';

  // colors
  static const Color MAIN_BASE_COLOR = Color(0xFF6A1B9A);

//  static const String URL_FRONT = 'http://apiinnovation.dyndns.org/alphadeal_frontend/public/';
//  static const String URL_BACK = 'http://apiinnovation.dyndns.org/alphadeal_backend/';

  static const String URL_FRONT = 'https://www.alphadeal54.com/';
  static const String URL_BACK = 'https://www.alphadeal54.com/admin/';

  static const String MAIN_URL_SERVICES     = URL_FRONT+'home/?app=';
  static const String CAT_URL_SERVICES      = URL_FRONT+'category/';
  static const String PDT_LIST_URL_SERVICES = URL_FRONT+'product_list/';
  static const String PDT_BND_LIST_URL_SERVICES = URL_FRONT+'product_brand/';
  static const String MAIN_URL_ASSETS       = URL_BACK+'storage/app/';

  static const String MAIN_URL_API          = URL_FRONT+'api/';
}