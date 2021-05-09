import 'package:flutter/material.dart';
import 'package:task_app_for_daniel/consts/app_colors.dart';

class FieldWithLabel extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller = TextEditingController();
  final Function(String) onChange;
  final FormFieldValidator<String> validator;
  final Function onFieldSubmitted;
  final TextInputType keyboardType;
  final TextStyle labelStyle;
  final Function onTap;
  final String initialValue;
  final FocusNode focusNode;
  final bool optional;
  final bool enabled;

  FieldWithLabel({
    Key key,
    this.labelText,
    this.hintText,
    this.onFieldSubmitted,
    this.validator,
    this.onChange,
    this.keyboardType = TextInputType.text,
    this.labelStyle,
    this.onTap,
    this.initialValue,
    this.focusNode,
    this.optional = false,
    this.enabled = true
  }) : super(key: key) {
    if (this.initialValue != null && this.initialValue.isNotEmpty) {
      this.controller.text = this.initialValue;
      this.controller.selection =
          TextSelection.collapsed(offset: this.initialValue.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(context),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            autofocus: false,
            enabled: enabled ?? true,
            onTap: this.onTap,
            focusNode: focusNode,
            onChanged: (value) {
              if (this.onChange != null) {
                this.onChange(value);
              }
            },
            validator: validator,
            controller: controller,
            decoration: getInputDecoration(context),
            keyboardType: keyboardType,
          ),
        ],
      ),
    );
  }

  OutlineInputBorder getBorder({Color borderColor = AppColors.placeholders}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide(
        color: borderColor,
        width: 1.0,
      ),
    );
  }

  Widget buildLabel(BuildContext context) {
    if (!optional) {
      return Text(
        labelText,
        style: labelStyle ?? TextStyle(
          fontSize: 20,
          color: Colors.black
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: labelStyle ?? Theme.of(context).textTheme.caption,
          ),
          Text(
            "Optional",
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      );
    }
  }

  InputDecoration getInputDecoration(BuildContext context) {
    if ( enabled ) {
      return InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 13.0,
            horizontal: 20.0,
          ),
          hintText: this.hintText,
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: AppColors.contentText
          ),
          border: getBorder(),
          focusedBorder: getBorder(borderColor: AppColors.primaryColor),
          errorStyle: Theme
              .of(context)
              .textTheme
              .bodyText2,
          fillColor: Colors.white,
          filled: true
      );
    } else {
      return InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 13.0,
          horizontal: 20.0,
        ),
        filled: true,
        fillColor: AppColors.itemBG,
        hintText: this.hintText,
        hintStyle: Theme
            .of(context)
            .textTheme
            .bodyText1,
        border: getBorder(),
        focusedBorder: getBorder(borderColor: AppColors.primaryColor),
        errorStyle: Theme
            .of(context)
            .textTheme
            .bodyText2,
      );
    }
  }
}
