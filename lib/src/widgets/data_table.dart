part of template;

class DataTableCustom extends StatefulWidget {
  DataTableCustom({
    super.key,
    required this.columns,
    required this.rows,
    this.height,
    this.dataRowHeight,
    this.scrollController,
    this.paddingHorzi,
    this.onLoadMore,
    this.headingColor,
    this.borderRadius,
    this.backgoundColor,
    this.minWidth,
    // this.minHeight,
  });
  double? height;
  double? paddingHorzi;
  List<DataColumn2> columns;
  List<DataRow> rows;
  double? dataRowHeight;
  ThemeColorExtension? _themeColorEx;
  ScrollController? scrollController;
  Function? onLoadMore;
  Color? headingColor;
  double? borderRadius;
  Color? backgoundColor;
  double? minWidth;
  // double? minHeight;
  @override
  State<DataTableCustom> createState() => _DataTableCustomState();
}

class _DataTableCustomState extends State<DataTableCustom> {
  ThemeColorExtension? _themeColorEx;

  @override
  void initState() {
    _onscroll();
    super.initState();
  }

  void _onscroll() {
    if (widget.scrollController != null) {
      widget.scrollController?.addListener(
        () {
          if (widget.scrollController!.position.pixels >= widget.scrollController!.position.maxScrollExtent) {
            widget.onLoadMore?.call();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    // widget.scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _themeColorEx = Theme.of(context).extension<ThemeColorExtension>();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadius ?? 8),
        topRight: Radius.circular(widget.borderRadius ?? 8),
      ),
      child: Container(
        color: Colors.white,
        child: DataTable2(
          scrollController: widget.scrollController,
          dataRowColor: WidgetStateProperty.all(widget.backgoundColor ?? Colors.white),
          columnSpacing: 12,
          horizontalMargin: widget.paddingHorzi ?? 12,
          minWidth: widget.minWidth,

          headingRowHeight: 40,
          headingRowColor: WidgetStatePropertyAll(
            widget.headingColor ?? _themeColorEx?.ksPrimary,
          ),
          headingTextStyle: const TextStyle(color: Colors.white),
          dataRowHeight: widget.dataRowHeight,
          // fixedColumnsColor: Colors.red,
          isHorizontalScrollBarVisible: true,
          isVerticalScrollBarVisible: true,

          // columnSpacing: 12,
          // horizontalMargin: 12,
          columns: widget.columns,
          showCheckboxColumn: false,
          rows: widget.rows,
        ),
      ),
    );
  }
}
