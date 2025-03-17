part of template;

class LoadMoreListView extends StatefulWidget {
  const LoadMoreListView({
    required this.itemBuilder,
    required this.itemCount,
    this.onLoadMore,
    this.scrollController,
    super.key,
    this.separatorBuilder,
    this.padding,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final ScrollController? scrollController;
  final Function? onLoadMore;
  final EdgeInsets? padding;

  @override
  State<LoadMoreListView> createState() => _LoadMoreListViewState();
}

class _LoadMoreListViewState extends State<LoadMoreListView> {
  final _debouncer = Debouncer(milliseconds: 250);

  @override
  void initState() {
    _onScroll();
    super.initState();
  }

  void _onScroll() {
    if (widget.scrollController != null && widget.onLoadMore != null) {
      widget.scrollController?.addListener(
        () {
          if (widget.scrollController!.position.pixels >=
              widget.scrollController!.position.maxScrollExtent) {
            _debouncer.run(() {
              widget.onLoadMore?.call();
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: widget.padding,
      controller: widget.scrollController,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: widget.separatorBuilder ?? (_, __) => const SizedBox(),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
