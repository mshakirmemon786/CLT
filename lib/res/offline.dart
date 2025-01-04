
import 'package:flutter/material.dart';

import 'btn.dart';

Column reusbaleofflinepage(BuildContext context, Function ontap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Image.asset('assets/nointernet.png'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Text(
            "whoops!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            "No Internet connection found. Check \nyour connection or try again",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
        ],
      ),
      reusablebtn(context, "Try again", Colors.orange, 0.8, () {
        ontap(); // Close the dialog
      })
    ],
  );
}
