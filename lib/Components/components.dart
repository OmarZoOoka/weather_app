import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget loginButton(
  void Function()? function, {
  double widt = double.infinity,
  double heigh = 45,
  bool isUpper = true,
  Color backcolor = Colors.blue,
  Color Textcolor = Colors.white,
  double circular = 25,
  String buttonText = "Login",
  double textSize = 22,
}) =>
    Container(
      decoration: BoxDecoration(
          color: backcolor, borderRadius: BorderRadius.circular(circular)),
      width: widt,
      height: heigh,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? buttonText.toUpperCase() : buttonText,
          style: TextStyle(color: Textcolor, fontSize: textSize),
        ),
      ),
    );

Widget Input(
        {@required TextEditingController? con,
        @required String? lab,
        String hint = "",
        bool isObsecure = false,
        void Function(String)? oFS,
        void Function(String)? oC,
        TextInputType enter = TextInputType.visiblePassword,
        @required Icon? pre,
        IconData? suf,
        void Function()? suffunf,
        String? Function(String?)? validate,
        List<TextInputFormatter>? inputFormatters,
        String? initialValue,
        bool readOnly = false}) =>
    TextFormField(
      validator: validate,
      controller: con,
      obscureText: isObsecure,
      onFieldSubmitted: oFS,
      readOnly: readOnly,
      onChanged: oC,
      inputFormatters: inputFormatters,
      keyboardType: enter,
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: lab,
          hintText: hint,
          border: const OutlineInputBorder(),
          prefixIcon: pre,
          suffixIcon: IconButton(onPressed: suffunf, icon: Icon(suf))),
    );
