part of template;

/// A custom text field widget.
///
/// This widget provides a customizable text field with built-in validation,
/// optional prefix icon, and optional visibility toggle for password fields.
///
/// To use this widget, simply create a new instance of `PuTextField` and provide
/// the required parameters. You can also provide any of the optional parameters
/// to further customize the text field.
class AppTextField extends StatefulWidget {
  /// The controller for the text field.
  ///
  /// This is required to manage the text field's state.

  final TextEditingController controller;

  /// An optional prefix icon to display before the text field.
  ///
  /// If not provided, no prefix icon will be displayed.

  final Widget? prefixIcon;

  /// The suffix icon to display at the end of the text field.
  ///
  /// If not provided, a visibility icon will be used for password fields when [obscureText] = true.
  final Widget? suffixIcon;

  /// The hint text to display when the text field is empty.
  ///
  ///  This provide a hint to the user about what they should enter in the text field.
  final String? hintText;

  /// The label text to display above the text field.
  ///
  ///  This provide a label to the user about what they should enter in the text field.
  final String? labelText;

  /// A function to validate the text field's input.
  ///
  /// This is required to provide feedback to the user about the validity of their input.

  final String? Function(String?)? validator;

  /// The type of keyboard to display for the text field.
  ///
  ///  Defaults to `TextInputType.text`, which displays a standard keyboard.

  final TextInputType keyboardType;

  /// Whether the text field is a password field.
  ///
  /// If true, the text field will hide its input. Defaults to false.

  final bool obscureText;

  ///
  /// The minimum number of lines for the text field. Defaults to 1.
  ///
  final int? minLines;

  /// The maximum number of lines for the text field.
  ///
  /// If not provided, the text field will automatically expand to accommodate additional lines of input.
  final int? maxLines;

  /// A function to call when the text field's input changes.
  ///
  ///  This is required to handle the text field's input.
  final void Function(String)? onChanged;

  /// The color of the text field's text.
  ///
  /// If not provided, the text color will default to the current theme's text color.
  final Color? colorText;

  /// Whether the text field is enabled.
  ///
  /// If false, the text field will be disabled and will not respond to input.
  ///
  ///  Defaults to true.
  final bool enable;

  /// The background color of the text field.
  ///
  /// If not provided, the background color will default to the current theme's background color.
  final Color? backgroundColor;

  /// The border radius of the text field.
  ///
  /// If not provided, the border radius will default to PuBorderRadius.ksRadius040.
  final BorderRadius? borderRadius;

  /// The border color of the text field.
  ///
  /// If not provided, the border color will default to the current theme's border color.
  final Color? borderColor;

  /// Whether to show a shadow behind the text field.
  ///
  /// If true, a shadow will be displayed behind the text field.
  ///
  ///  Defaults to false.
  final bool? showShadow;

  /// The box shadow to display behind the text field.
  ///
  ///  If not provided, no shadow will be displayed.
  final BoxShadow? boxShadow;

  /// The focus node for the text field.
  ///
  /// This is used to determine whether this text field currently has the user's focus.
  ///
  /// If not provided, the text field will create its own `FocusNode`.
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;

  /// The font size of the text field's text.
  ///
  /// If not provided, the font size will default to 16.sp.
  final double? fontSize;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? title;
  final Widget? helpTitleWidget;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    this.onChanged,
    this.colorText,
    this.enable = true,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.showShadow = true,
    this.boxShadow,
    this.focusNode,
    this.fontSize,
    this.style,
    this.hintStyle,
    this.title,
    this.contentPadding,
    this.isRequired = false,
    this.inputFormatters,
    this.helpTitleWidget,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PuTextField createState() => _PuTextField();
}

class _PuTextField extends State<AppTextField> {
  bool isHideText = false;
  bool isShowSuccessValidate = false;
  String validFiled = "";
  late ThemeColorExtension? themeColor;

  OutlineInputBorder? get border {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 0.7,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  void initStateTextInput(bool showText) {
    isHideText = showText;
  }

  void changeStateShowText() {
    setState(() {
      isHideText = !isHideText;
    });
  }

  void changeCheckShowValidate(bool check) {
    setState(() {
      isShowSuccessValidate = check;
    });
  }

  void showLabelText() {
    setState(() {
      isShowSuccessValidate = true;
    });
  }

  void updateValidField(String? v) {
    setState(() {
      validFiled = v ?? "";
    });
  }

  @override
  void initState() {
    initStateTextInput(widget.obscureText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeColor = Theme.of(context).extension<ThemeColorExtension>();
    return _buildTextField();
  }

  void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                // maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: widget.isRequired == true ? FontWeight.bold : null,
                          ),
                    ),
                    if (widget.isRequired)
                      TextSpan(
                        text: "*",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                  ],
                ),
              ),
              if (widget.helpTitleWidget != null) const Gap(6),
              if (widget.helpTitleWidget != null)
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: widget.helpTitleWidget,
                  ),
                ),
            ],
          ),
        if (widget.title != null) const Gap(10),
        Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: widget.enable ? (widget.showShadow! ? [AppBoxShadow.ksSmallShadow(blurRadius: 5)] : null) : null,
          ),
          child: TextFormField(
            inputFormatters: widget.inputFormatters,
            focusNode: widget.focusNode,
            onTapOutside: (event) {
              hideKeyboard();
            },
            enabled: widget.enable,
            onTap: showLabelText,
            style: widget.style ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: widget.fontSize ?? 16,
                      height: 1.5,
                    ),
            decoration: _buildInputDecoration(),
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: isHideText,
            minLines: widget.minLines,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            validator: (v) {
              if (widget.validator != null) {
                updateValidField(widget.validator!(v));
                return widget.validator!(v);
              }
            },
          ),
        ),
        if (validFiled.isNotEmpty) // Only show the error message if it's not empty
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8),
            child: Text(
              validFiled,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeColor?.ksError, // Use red color for error messages
                  ),
            ),
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    var inputDecoration = InputDecoration(
      isDense: true,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      fillColor: widget.backgroundColor ?? themeColor?.ksBackground3 ?? Colors.white,
      prefixIconConstraints: BoxConstraints(
        minWidth: 32,
        maxWidth: 100,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: 32,
        maxWidth: 100,
      ),
      filled: true,
      errorText: null,
      errorMaxLines: 3,
      errorStyle: const TextStyle(fontSize: 0),
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          TextStyle(
            color: widget.colorText ?? themeColor?.ksBody.withOpacity(0.45) ?? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.45),
            fontWeight: FontWeight.w400,
            fontSize: widget.fontSize ?? 14,
            height: 1.5,
          ),
      labelText: widget.labelText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.errorContainer, width: 0.7),
        borderRadius: BorderRadius.circular(4.0),
      ),
      border: border,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
    return inputDecoration;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon == null && !widget.obscureText) {
      return null;
    }
    return Container(
      child: widget.suffixIcon ??
          (widget.obscureText
              ? InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: changeStateShowText,
                  child: Icon(
                    isHideText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: themeColor?.ksBody.withOpacity(0.26) ?? Theme.of(context).primaryColor,
                  ),
                )
              : Container(
                  width: 1,
                )),
    );
  }
}
