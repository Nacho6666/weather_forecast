import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constant.dart';

class InputTextFieldView extends StatefulWidget {
  const InputTextFieldView({
    super.key,
    this.svgAsset,
    this.focusNode,
    this.textEditingController,
    this.labelText,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.fillColor,
    this.autofocus = false,
    this.obscureText = false,
    this.onTap,
    this.onFocusChanged,
    this.keyboardType = TextInputType.emailAddress,
    this.cursorColor = Colors.brown,
    this.hintTextColor = Colors.grey,
    this.borderColor = Colors.brown,
    this.enabledBorderColor = Colors.brown,
    this.focusedBorderColor = Colors.brown,
    this.errorColor = Colors.red,
    this.contentPadding,
    this.borderRadius = const BorderRadius.all(Radius.circular(3.0)),
    this.prefixIconWidth,
    this.prefixIconColor,
    this.showErrorText = true,
    this.maxLines,
    this.enable,
    this.minLines,
  });

  final String? svgAsset;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool autofocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final void Function(FocusNode)? onFocusChanged;
  final Color cursorColor;
  final Color hintTextColor;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color borderColor;
  final Color errorColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius borderRadius;
  final double? prefixIconWidth;
  final Color? prefixIconColor;
  final bool showErrorText;
  final int? maxLines;
  final int? minLines;
  final bool? enable;

  @override
  State<InputTextFieldView> createState() => _InputTextFieldViewState();
}

class _InputTextFieldViewState extends State<InputTextFieldView> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;
  late bool obscureText = widget.obscureText;
  late Color cursorColor = widget.cursorColor;
  late Color hintTextColor = widget.hintTextColor;
  late Color enabledBorderColor = widget.enabledBorderColor;
  late Color focusedBorderColor = widget.focusedBorderColor;
  late Color borderColor = widget.borderColor;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textEditingController ?? TextEditingController();
    _focusNode = (widget.focusNode ?? FocusNode())..addListener(() => widget.onFocusChanged?.call(_focusNode));
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) {
      _textEditingController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checkTextColor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          enabled: widget.enable,
          maxLines: widget.maxLines,
          cursorWidth: 1,
          autofocus: widget.autofocus,
          cursorColor: cursorColor,
          focusNode: _focusNode,
          controller: _textEditingController,
          obscureText: obscureText,
          textInputAction: TextInputAction.done,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          onTapOutside: (event) => _focusNode.unfocus(),
          style: AppFont.subtitle(textColor: ColorResource.primary),
          decoration: InputDecoration(
            isDense: true,
            filled: widget.fillColor != null,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            labelText: widget.labelText,
            labelStyle: AppFont.subtitle(textColor: hintTextColor),
            fillColor: widget.fillColor,
            contentPadding: widget.contentPadding ?? const EdgeInsetsDirectional.only(end: 12),
            border: OutlineInputBorder(borderRadius: widget.borderRadius, borderSide: BorderSide(width: 1, color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: widget.borderRadius, borderSide: BorderSide(width: 1, color: enabledBorderColor)),
            errorBorder: OutlineInputBorder(borderRadius: widget.borderRadius, borderSide: BorderSide(width: 1, color: enabledBorderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: widget.borderRadius, borderSide: BorderSide(width: 1, color: focusedBorderColor)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: widget.borderRadius, borderSide: BorderSide(width: 1, color: focusedBorderColor)),
            hintText: widget.hintText,
            hintStyle: AppFont.subtitle(textColor: hintTextColor),
          ),
        ),
        if (widget.showErrorText)
          Text(
            widget.errorText ?? '',
            style: AppFont.tag(textColor: cursorColor),
          ),
      ],
    );
  }

  _checkTextColor() {
    if (widget.errorText?.isNotEmpty == true) {
      cursorColor = hintTextColor = enabledBorderColor = focusedBorderColor = ColorResource.error;
      return;
    }
    cursorColor = widget.cursorColor;
    hintTextColor = widget.hintTextColor;
    enabledBorderColor = widget.enabledBorderColor;
    focusedBorderColor = widget.focusedBorderColor;
  }

  Widget? get prefixIcon {
    if (widget.svgAsset?.isNotEmpty != true) return null;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null)
            widget.prefixIcon!
          else
            SvgPicture.asset(
              widget.svgAsset!,
              width: widget.prefixIconWidth ?? 16,
              colorFilter: ColorFilter.mode(widget.prefixIconColor ?? ColorResource.border, BlendMode.srcIn),
            ),
        ],
      ),
    );
  }

  Widget? get suffixIcon {
    if (!widget.obscureText) return null;
    return GestureDetector(
      onTap: () {
        obscureText = !obscureText;
        if (mounted) setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsetsDirectional.only(end: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icon_eye_off.svg',
              width: 16,
              colorFilter: const ColorFilter.mode(ColorResource.border, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
