import 'package:flutter/material.dart';

class CustomtTextField extends TextField {
  CustomtTextField(
      {super.key,
      required TextEditingController controller,
      required String label,
      TextInputType? inputType,
      bool? isObscureText})
      : super(
          controller: controller,
          obscureText: isObscureText ?? false,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
        );
}
