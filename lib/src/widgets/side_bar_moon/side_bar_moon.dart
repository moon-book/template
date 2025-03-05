// ignore_for_file: public_member_api_docs, sort_constructors_first
part of template;

class SidebarMoon extends StatefulWidget {
  // ignore: public_member_api_docs
  SidebarMoon({
    Key? key,
    required this.dio,
    required this.tagId,
    required this.projectName,
    this.getIconWithName,
    this.backgroundColor,
    // this.onTreeReady,
    this.initRoute,
    this.avatar,
    this.fullnameUser,
    this.onChangeFeature,
    this.itemBuilder,
    this.onTapLogout,
    this.expandAll,
    this.isExpandedSideBar = true,
    this.width,
    this.showShadow = true,
  }) : super(key: key);
  Dio dio;
  int tagId;
  String projectName;
  String? avatar;
  String? fullnameUser;
  Color? backgroundColor;
  bool? expandAll;
  bool isExpandedSideBar;
  double? width;
  bool showShadow;

  ///hàm này trả về icon theo iconurl từ be trả về nhé ae
  Widget Function(String iconUrl)? getIconWithName;
  void Function(TreeNodeExt item, BuildContext context)? onChangeFeature;
  // void Function(TreeViewController<TreeNodeExt, TreeNode<TreeNodeExt>>)? onTreeReady;
  String? initRoute;
  Widget Function(
    BuildContext context,
    TreeNodeExt item,
    bool isSelected,
  )? itemBuilder;

  Function? onTapLogout;
  @override
  State<SidebarMoon> createState() => _SidebarMoonState();
}

class _SidebarMoonState extends State<SidebarMoon> with AutomaticKeepAliveClientMixin {
  SideMenuController sideMenu = SideMenuController();

  late SideBarService _service;
  //danh mục menu nhé ae
  List<TreeNodeExt> features = [];
  TreeNodeExt? featureSelected;
  bool isExpandedSideBar = true;
  List<bool> initExpandedItem = [true];
//call api lay ra danh sach feature
  Future<BaseModel<List<FeatureMenuModel>>> getFeature() async {
    final data = await _service.getFeature(
      tagId: widget.tagId,
      projectName: widget.projectName,
    );
    for (var i = 0; i < data.data!.length; i++) {
      if (data.data![i].children!.isNotEmpty) {
        initExpandedItem.add(true);
      }
    }
    final feat = buildTreeNodes(
      data.data ?? [],
    );
    if (widget.initRoute != null) {
      for (var i = 0; i < feat.length; i++) {
        if (widget.initRoute!.split('/').length <= 2) {
          //khogn co con
          if (widget.initRoute == feat[i].pathRouter) {
            sideMenu.changePage(i);
          }
        } else {
          //co con
          for (var j = 0; j < feat[i].children.length; j++) {
            if (widget.initRoute!.split('/').last == feat[i].children[j].pathRouter) {
              sideMenu.changePage(i + j);
            }
          }
        }
      }
    }
    setState(() {
      features.addAll(feat);
    });

    // sideMenu.changePage(3);
    return data;
  }

  List<TreeNodeExt> buildTreeNodes(
    List<FeatureMenuModel> menuItems, {
    String? parentPathRouter,
    TreeNodeExt? parent,
  }) {
    int index = 0;
    var data = menuItems.map(
      (item) {
        Widget icon = Container();
        if (item.iconUrl?.contains('https://') ?? false) {
          icon = Image(image: NetworkImage(item.iconUrl!));
        } else {
          icon = widget.getIconWithName?.call(item.iconUrl ?? '') ?? Container();
        }
        final treeNode = TreeNodeExt(
          // key: '${item.featureId}',
          name: item.featureName ?? '',
          pathRouter: item.route ?? '',
          parentPathRouter: parentPathRouter,
          parent: parent,
          icon: icon, // Icon(Icons.show_chart_sharp),
        );
        if (widget.initRoute != null) {
          if (widget.initRoute!.contains(item.route ?? '')) {
            featureSelected = treeNode;
            // sideMenu.changePage(index);
          }
          final subPaths = widget.initRoute!.split('/');
          if (subPaths.length > 2) {
            if ('${treeNode.parentPathRouter}/${treeNode.pathRouter}' == widget.initRoute!) {
              print("xzxzxz $index");
              initExpandedItem[index] = true;
              featureSelected = treeNode;
            }
          }
        }

        if (item.children != null && item.children!.isNotEmpty) {
          treeNode.children = buildTreeNodes(
            item.children!.cast<FeatureMenuModel>(),
            parentPathRouter: item.route,
            parent: treeNode,
          );
        }
        index++;
        return treeNode;
      },
    ).toList();

    return data;
  }

  @override
  void initState() {
    isExpandedSideBar = widget.isExpandedSideBar;
    _service = SideBarService(widget.dio);
    getFeature();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SidebarMoon oldWidget) {
    if (oldWidget.isExpandedSideBar != widget.isExpandedSideBar) {
      setState(() {
        isExpandedSideBar = widget.isExpandedSideBar;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return sideBar();
  }

  Widget _renderUser() {
    return Container(
      alignment: Alignment.centerRight,
      // padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.avatar?.isNotEmpty ?? false)
            CircleAvatar(
              radius: 18,
              foregroundImage: NetworkImage(
                widget.avatar ?? '',
              ),
            )
          else
            const CircleAvatar(
              radius: 24,
              // foregroundImage: AssetImage(Assets.images.defaultAvatar.path),
            ),
          const Gap(10),
          SizedBox(
            child: Text(
              widget.fullnameUser ?? '',
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    // color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sideBar() {
    return AnimatedSwitcher(
      key: UniqueKey(),
      duration: const Duration(milliseconds: 3000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        width: widget.width ?? (isExpandedSideBar ? 250 : 40),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          border: isExpandedSideBar
              ? const Border(
                  right: BorderSide(
                    color: Color.fromARGB(31, 211, 211, 211),
                  ),
                )
              : null,
          boxShadow: isExpandedSideBar && widget.showShadow
              ? [
                  AppBoxShadow.ksSmallShadow(
                    color: const Color.fromARGB(31, 144, 144, 144),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            if (isExpandedSideBar)
              Container(
                padding: const EdgeInsets.all(16),
                child: _renderUser(),
              ),
            if (features.isNotEmpty && isExpandedSideBar)
              Expanded(
                child: Theme(
                  data: ThemeData().copyWith(
                    dividerColor: Colors.transparent,

                    // canvasColor: Colors.blue,
                    // drawerTheme: DrawerThemeData(
                    //   backgroundColor: Colors.red,
                    // ),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: SideMenu(
                      controller: sideMenu,
                      items: List.generate(
                        features.length,
                        (index) {
                          if (features[index].children.isEmpty) {
                            //cha
                            return SideMenuItem(
                              title: features[index].name,
                              onTap: (index, _) {
                                sideMenu.changePage(index);
                                widget.onChangeFeature?.call(features[index], context);
                              },
                              iconWidget: features[index].icon,
                            );
                          } else {
                            //cha chua con
                            return SideMenuExpansionItem(
                              title: features[index].name,
                              iconWidget: features[index].icon,
                              // onTap: (index, c, isExpanded) {},
                              children: List.generate(
                                features[index].children.length,
                                (i) {
                                  return SideMenuItem(
                                    title: features[index].children[i].name,
                                    onTap: (x, _) {
                                      sideMenu.changePage(x);
                                      widget.onChangeFeature?.call(features[index].children[i], context);
                                    },
                                    iconWidget: features[index].children[i].icon,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      style: SideMenuStyle(
                        displayMode: SideMenuDisplayMode.open,
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.12),
                        backgroundColor: Colors.transparent,
                        selectedTitleTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                        unselectedTitleTextStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14, color: Colors.black, // thêm màu cho mobile fallback
                        ),
                        arrowOpen: Theme.of(context).primaryColor,
                      ),
                      expansionStateListInit: initExpandedItem,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isExpandedSideBar)
                  Expanded(
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          widget.onTapLogout?.call();
                        },
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            Gap(12),
                            Text(
                              'Đăng xuất',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpandedSideBar = !isExpandedSideBar;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: isExpandedSideBar ? 0 : 12),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isExpandedSideBar ? Icons.navigate_before : Icons.menu_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
