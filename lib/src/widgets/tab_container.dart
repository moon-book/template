part of template;

class TabContainerWidget extends StatefulWidget {
  final List<Widget> children;
  final List<String> title;
  final double? sizeTabLength;

  const TabContainerWidget({
    Key? key,
    required this.children,
    required this.title,
    this.sizeTabLength,
  }) : super(key: key);

  @override
  _TabContainerWidgetState createState() => _TabContainerWidgetState();
}

class _TabContainerWidgetState extends State<TabContainerWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.title.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TabBar
        Container(
          color: Colors.white,
          child: TabBar(
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            labelPadding: EdgeInsets.symmetric(horizontal: 0), // Chỉ padding riêng cho tab

            isScrollable: true,
            indicator: BoxDecoration(
              color: Colors.blue, // Màu nền tab active
              borderRadius: BorderRadius.circular(8),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: widget.title.map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 12), child: Tab(text: e))).toList(),
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
