import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onpress;

  const  RoundButton(
      {Key? key,
      required this.title,
       this.loading = false,
      required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
          color:Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading ?  const CircularProgressIndicator(color: Colors.white, strokeWidth: 3, ) :
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
