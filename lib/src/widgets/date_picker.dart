part of template;

class DatePickerField extends StatefulWidget {
  DatePickerField({
    super.key,
    this.title = '',
    this.hintText,
    this.onChanged,
    this.initDate,
    this.isRequired = false,
    this.enable = true,
    this.validator,
    this.isVertical = true,
    this.contentPadding,
    this.showPrefixIcon = true,
    this.style,
    this.hintStyle,
    this.enableInitValue = true,
    this.errorStyle,
    this.controller,
  });
  String title;
  String? hintText;
  Function? onChanged;
  DateTime? initDate;
  bool isRequired;
  bool enable;
  bool isVertical;
  String? Function(dynamic)? validator;
  EdgeInsets? contentPadding;
  bool showPrefixIcon;
  TextStyle? style;
  TextStyle? hintStyle;
  TextStyle? errorStyle;
  TextEditingController? controller;
  bool enableInitValue;
  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime selectedDate = DateTime.now();
  DateTime? initDate;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initDate = widget.initDate;
    if (widget.enableInitValue) {
      controller.text = (widget.initDate ?? DateTime.now()).toString().toDateTimeString(format: 'yyyy-MM-dd') ?? '';
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    if (oldWidget.initDate.toString() != widget.initDate.toString()) {
      setState(() {
        initDate = widget.initDate;
        if (widget.enableInitValue) {
          controller.text = (widget.initDate ?? DateTime.now()).toString().toDateTimeString(format: 'yyyy-MM-dd') ?? '';
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: FormField(
        validator: (value) {
          return widget.validator?.call(selectedDate);
        },
        builder: (field) {
          if (widget.isVertical) {
            return InkWell(
              onTap: () {
                _selectDate(context, field);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title.isNotEmpty)
                    RichText(
                      // maxLines: 1,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.title,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black38,
                            ),
                          ),
                          if (widget.isRequired)
                            const TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  if (widget.title.isNotEmpty) const Gap(6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            AppBoxShadow.ksSmallShadow(),
                          ],
                        ),
                        child: AppTextField(
                          contentPadding: widget.contentPadding,
                          isRequired: widget.isRequired,
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          hintText: widget.hintText ?? widget.title,
                          backgroundColor: Colors.white,
                          borderColor: field.hasError ? Colors.red : Colors.transparent,
                          hintStyle: widget.hintStyle,
                          // title: widget.title,
                          style: widget.style,

                          showShadow: true,
                          enable: false,
                          prefixIcon: widget.showPrefixIcon
                              ? Icon(
                                  Icons.date_range,
                                  color: Theme.of(context).primaryColor,
                                )
                              : null,
                        ),
                      ),
                      if (field.hasError)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(
                            field.errorText ?? '',
                            style: widget.errorStyle ??
                                TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            );
          }
          return InkWell(
            onTap: () {
              _selectDate(context, field);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  // maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(text: widget.title, style: TextStyle(overflow: TextOverflow.ellipsis)),
                      if (widget.isRequired)
                        const TextSpan(
                          text: "*",
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                const Gap(6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            AppBoxShadow.ksSmallShadow(),
                          ],
                        ),
                        child: AppTextField(
                          isRequired: widget.isRequired,
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          hintText: widget.title,
                          backgroundColor: Colors.white,
                          borderColor: field.hasError ? Colors.red : Colors.transparent,

                          // title: widget.title,
                          showShadow: true,
                          enable: false,
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      if (field.hasError)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(
                            field.errorText ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _selectDate(
    BuildContext context,
    FormFieldState<Object?> field,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 4),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(),
          ),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      field.didChange(picked);
      setState(() {
        selectedDate = picked;
        String date = selectedDate.toString().toDateTimeString(format: "yyyy-MM-dd");
        controller.text = date;
        widget.onChanged?.call(selectedDate);
      });
    }
  }
}
