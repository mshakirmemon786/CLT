import 'package:flutter/material.dart';

import '../controller/colors.dart';

// Padding reusabletextfield(
//   TextEditingController controller,
//   bool icn_or_not,
//   String label,
//   IconData icn,
//   bool validate_or_not){
//   return Padding(
//     padding: EdgeInsets.only(bottom:10),
//     child: TextFormField(
//       validator: (value) {
//             if(validate_or_not==true){
//               if (value!.isEmpty) {
//                 return 'This Field is required.';
//               }
//               return null;
//             }

//             },
//       style: TextStyle(color: colorController.greytextfieldlableclr),
//                   controller: controller,

//              decoration:  InputDecoration(
//             focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),

//               hintStyle: TextStyle(
//                                      color: colorController.normalgreenbtnclr,

//               ),
//                hintText: label,
//                         fillColor: colorController.normalgreenbtnclr,
//                           filled: false,
//                          contentPadding:  EdgeInsets.all(0),

//                           enabledBorder:  OutlineInputBorder(
//                             borderRadius:  BorderRadius.circular(6.0,),
//                             borderSide: BorderSide(color: colorController.normalgreenbtnclr,width: 1.5)

//                           ),
//                             prefixIcon: Icon(icn_or_not==true?icn:null,
//               color:colorController.normalgreenbtnclr,
//               )

//                        ),
//                     ),
//   );
// }

Container reusabletextfield(
    BuildContext context,
    TextEditingController controller,
    bool icn_or_not,
    String label,
    IconData icn,
    bool validate_or_not,
    double height,
    double btmsize
    // Color clr,
    // Color txtclr
    ) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * height,
    padding: EdgeInsets.only(bottom: btmsize),
    child: TextFormField(
      validator: (value) {
        if (validate_or_not == true) {
          if (value!.isEmpty) {
            return 'This Field is required.';
          }
          return null;
        }
      },
      style: TextStyle(color: colorController.normalgreenbtnclr),
      controller: controller,
      decoration: InputDecoration(
      focusColor: Colors.black,
      focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorController.normalgreenbtnclr)),
      hintStyle: TextStyle(
        fontSize: 15,
      color: colorController.normalgreenbtnclr,
        ),
        prefixIcon: Icon(
          icn_or_not == true ? icn : null,
          color: colorController.normalgreenbtnclr,
        ),
        hintText: label,

        filled: false,
        contentPadding: EdgeInsets.only(left: 10),

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              6.0,
            ),
            borderSide: BorderSide(
                color: colorController.normalgreenbtnclr, width: 1.5)),
        //               prefixIcon: Icon(icn_or_not==true?icn:null,
        // color:colorController.normalgreenbtnclr,
        // )
      ),
    ),
  );
}

Padding reusablepasswordtextfield(TextEditingController controller,
    String label, bool show_or_hide, Function ontap, bool validate_or_not) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: TextFormField(
      validator: (value) {
        if (validate_or_not == true) {
          if (value!.isEmpty) {
            return 'This Field is required.';
          }
          return null;
        }
      },
      style: TextStyle(color: colorController.normalgreenbtnclr),
      controller: controller,
      obscureText: show_or_hide,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorController.normalgreenbtnclr)),
        hintStyle: TextStyle(
          color: colorController.normalgreenbtnclr,
        ),
        hintText: label,
        fillColor: colorController.normalgreenbtnclr,
        filled: false,
        contentPadding: EdgeInsets.all(0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              6.0,
            ),
            borderSide: BorderSide(color: colorController.normalgreenbtnclr)),
        prefixIcon: IconTheme(
            data: IconThemeData(
              color: colorController.normalgreenbtnclr,
            ),
            child: Icon(
              Icons.lock,
            )),
        suffixIcon: InkWell(
          onTap: () {
            ontap();
          },
          child: Icon(show_or_hide ? Icons.visibility_off : Icons.visibility,
              color: colorController.normalgreenbtnclr),
        ),
      ),
    ),
  );
}
