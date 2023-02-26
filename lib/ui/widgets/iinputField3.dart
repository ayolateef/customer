import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//
// ver 2.0 - 29/09/2020
//

class IInputField3 extends StatefulWidget {
  final String? hint;
  final IconData? icon;
  final IconData? iconRight;
  final Function() onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController? controller;
  final TextInputType? type;
  final Color? colorDefaultText;
  final Color? colorBackground;
  IInputField3(
      {this.hint,
      this.icon,
      this.controller,
      this.type,
      this.colorDefaultText,
      this.colorBackground,
      this.iconRight,
      required this.onPressRightIcon,
      required this.onChangeText});

  @override
  _IInputField3State createState() => _IInputField3State();
}

class _IInputField3State extends State<IInputField3> {
  @override
  Widget build(BuildContext context) {
    Color? _colorBackground = Colors.white;
    if (widget.colorBackground != null)
      _colorBackground = widget.colorBackground;
    Color? _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    Widget? _sicon = Icon(
      widget.icon,
      color: _colorDefaultText,
    );
    if (widget.icon == null) _sicon = null;

    var _sicon2;
    if (widget.iconRight != null)
      _sicon2 = InkWell(
          onTap: () {
            if (widget.onPressRightIcon != null) widget.onPressRightIcon();
          }, // needed
          child: Icon(
            widget.iconRight,
            color: _colorDefaultText,
          ));

    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: _colorBackground,
        border: Border.all(color: Colors.transparent),
        borderRadius: new BorderRadius.circular(20),
      ),
      child: new TextFormField(
        keyboardType: widget.type,
        controller: widget.controller,
        enabled: false,
        onChanged: (String value) async {
          if (widget.onChangeText != null) widget.onChangeText(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp("[\"]")),
        ],
        decoration: new InputDecoration(
          border: InputBorder.none,
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: _colorDefaultText, fontSize: 16.0),
        ),
      ),
    );
  }
}
