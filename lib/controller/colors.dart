import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {
  Color loginbtnclr = Colors.grey.shade300;
  Color normalgreenbtnclr = Color(0xff16462a);
  Color rederrortextclr = Color.fromARGB(255, 201, 55, 44);
  Color greytextfieldlableclr = Colors.grey;
  Color lightgreensplash = Color.fromARGB(255, 228, 255, 240);
  Color registerpagetextgreenclr = Color.fromARGB(255, 14, 51, 16);
  Color disablebtncolor = Colors.grey.shade300;
}

ColorController colorController = Get.put(ColorController());
