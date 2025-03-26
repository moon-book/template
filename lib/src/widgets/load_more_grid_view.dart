part of template;

class LoadMoreGridView extends StatefulWidget {
  const LoadMoreGridView({
    required this.itemBuilder,
    required this.itemCount,
    this.onLoadMore,
    this.scrollController,
    super.key,
    this.padding,
    this.gridDelegate,
    this.shrinkWrap,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final ScrollController? scrollController;
  final Function? onLoadMore;
  final EdgeInsets? padding;
  final SliverGridDelegate? gridDelegate;
  final bool? shrinkWrap;

  @override
  State<LoadMoreGridView> createState() => _LoadMoreGridViewState();
}

class _LoadMoreGridViewState extends State<LoadMoreGridView> {
  final _debouncer = Debouncer(milliseconds: 250,);

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
    return GridView.builder(
      shrinkWrap: widget.shrinkWrap ?? false,
      padding: widget.padding,
      controller: widget.scrollController,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      gridDelegate: widget.gridDelegate ??
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
