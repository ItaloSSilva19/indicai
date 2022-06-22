import 'package:flutter/material.dart';

class TelaSplash extends StatelessWidget {
  const TelaSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF49454F)),
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/graphics/indicai.png'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/homepage");
            },
            child: Text('PROSSEGUIR'),
          ),
        ],
      ),
    );
  }
}
