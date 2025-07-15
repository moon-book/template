part of template;

class AppBarCustom extends StatefulWidget {
  AppBarCustom({
    super.key,
    this.centerWidget,
    this.actions = const [],
    this.showBoxSearchCenter = false,
    this.onChangeBoxSearchCenter,
    this.currentPageNamed,
    this.mobileAppBar,
  });
  Widget? centerWidget;
  List<Widget> actions;
  bool showBoxSearchCenter;
  Function? onChangeBoxSearchCenter;
  Widget? currentPageNamed;
  Widget? mobileAppBar;
  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {
  ThemeColorExtension? _themeColorExt;
  late TextTheme textTheme;
  // test
  @override
  Widget build(BuildContext context) {
    _themeColorExt = Theme.of(context).extension<ThemeColorExtension>();
    textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          AppBoxShadow.ksSmallShadow(
            blurRadius: 12,
            spreadRadius: 0.2,
            color: const Color.fromARGB(31, 197, 197, 197),
          ),
        ],
      ),
      child: widget.mobileAppBar ??
          Row(
            children: [
              Expanded(
                // child: Container(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      // if (context.canPop())
                      //   IconButton(
                      //     onPressed: () {
                      //       if (context.canPop()) context.pop();
                      //     },
                      //     icon: const Icon(
                      //       Icons.navigate_before_outlined,
                      //       color: AppColors.primaryColor,
                      //     ),
                      //   ),
                      widget.currentPageNamed ??
                          Text(
                            'Page name',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: widget.centerWidget ?? (widget.showBoxSearchCenter ? _renderBoxSearch() : Container()),
              ),
              Container(
                padding: const EdgeInsets.only(right: 12),
                alignment: Alignment.centerRight,
                child: widget.actions.isNotEmpty ? widget.actions.first : Container(),
              ),
            ],
          ),
    );
  }

  final TextEditingController _textEditingController = TextEditingController();
  Widget _renderBoxSearch() {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppTextField(
        controller: _textEditingController,
        hintText: 'Nhập giá trị tìm kiếm',
        onChanged: (v) {
          widget.onChangeBoxSearchCenter?.call(v);
        },
        prefixIcon: Icon(
          Icons.search_rounded,
          color: _themeColorExt?.ksBody,
        ),
        borderColor: Colors.transparent,
        backgroundColor: _themeColorExt?.ksBackground3,
      ),
    );
  }
}
