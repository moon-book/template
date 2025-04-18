part of template;

typedef X<T> = Future<List<T>> Function(String)?;
typedef Future<List<T>> GetData<T>(String searchValue);
typedef BuilderSearchDropdown = Widget Function(
  BuildContext context,
  dynamic item,
  bool isSelected,
  Function listItemBuilder,
);
typedef RenderItem = Widget Function(dynamic item);

enum TypeDropdown {
  search,
  normal,
  multi_search_request,
  multi_search,
}

class SearchDropdown<T> extends StatefulWidget {
  SearchDropdown({
    super.key,
    this.getProductFunc,
    this.hintText,
    required this.renderItem,
    required this.builderItems,
    this.title,
    this.typeDropdown = TypeDropdown.normal,
    this.values,
    this.onChanged,
    this.isRequired,
    this.width,
    this.enable,
    this.initValue,
    this.validator,
    this.showShadow = true,
    this.overlayHeight,
    this.canCloseOutsideBounds = true,
    this.onListChanged,
    this.onDelete,
    this.initialItems,
    this.initValues,
    this.singleSelectController,
    this.multiSelectController,
  });
  final bool? enable;
  final X<T>? getProductFunc;
  final RenderItem renderItem;
  final String? hintText;
  final BuilderSearchDropdown builderItems;
  final String? title;
  List<T>? values;
  T? initValue;
  List<T>? initValues;
  bool showShadow;
  TypeDropdown typeDropdown;
  Function(dynamic?)? onChanged;
  Function(List<dynamic>, {bool? isDelete})? onListChanged;
  Function(dynamic)? onDelete;

  String? Function(dynamic)? validator;
  bool canCloseOutsideBounds;
  double? overlayHeight;
  double? width;
  bool? isRequired;
  List<T>? initialItems;
  SingleSelectController<T?>? singleSelectController;
  MultiSelectController<T>? multiSelectController;
  @override
  State<SearchDropdown> createState() => _SearchDropdownState<T>();
}

class _SearchDropdownState<T> extends State<SearchDropdown> {
  bool isLoading = false;
  List<dynamic>? data = [];
  SingleSelectController<T?>? singleSelectController;
  MultiSelectController<T>? multiSelectController;
  @override
  void initState() {
    data = widget.values;
    if (widget.singleSelectController != null) {
      singleSelectController = (widget.singleSelectController!..value = widget.initValue as T?) as SingleSelectController<T?>?;
    } else {
      singleSelectController = SingleSelectController(widget.initValue as T?);
    }
    if (widget.typeDropdown == TypeDropdown.multi_search ||
        // ignore: curly_braces_in_flow_control_structures
        widget.typeDropdown == TypeDropdown.multi_search_request) {
      if (widget.multiSelectController != null) {
        multiSelectController = (widget.multiSelectController!)
            // ..value = (widget.initialItems ?? <T>[]) as List<T>)
            as MultiSelectController<T>?;
      } else {
        multiSelectController = MultiSelectController((widget.initialItems ?? <T>[]) as List<T>);
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchDropdown oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (oldWidget.enable != widget.enable || oldWidget.values != widget.values) {
          setState(() {
            data = widget.values;
          });
          // singleSelectController!.value = widget.initValue as T?;
          // if (multiSelectController != null) {
          //   multiSelectController?.value =
          //       (widget.initValues as List<T>?) ?? [];
          // }
        }
      },
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (v) {
        if (widget.validator != null) {
          if (multiSelectController != null) {
            return widget.validator!(multiSelectController?.value);
          } else {
            return widget.validator!(singleSelectController?.value);
          }
        }
        return null;
      },
      builder: (field) {
        Widget dropdown = Container();
        switch (widget.typeDropdown) {
          case TypeDropdown.search:
            dropdown = CustomDropdown<T>.searchRequest(
              controller: singleSelectController,
              enabled: widget.enable ?? true,
              overlayHeight: widget.overlayHeight,

              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              futureRequest: (p0) => widget.getProductFunc!(p0) as Future<List<T>>,
              hintText: widget.hintText ?? 'Search value',
              hintBuilder: (context, hint, enabled) => Text(
                widget.hintText ?? 'Search value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              // items: data,
              listItemBuilder: widget.builderItems,
              decoration: CustomDropdownDecoration(
                closedErrorBorder: Border.all(color: Colors.red, width: 1),
                closedBorderRadius: BorderRadius.circular(8),
                closedShadow: widget.showShadow
                    ? [
                        AppBoxShadow.ksSmallShadow(),
                      ]
                    : null,
              ),
              onChanged: (p) {
                widget.onChanged?.call(p);
              },
              // itemsListPadding: const EdgeInsets.only(bottom: 100),
              closeDropDownOnClearFilterSearch: true,
              // excludeSelected: false,
              canCloseOutsideBounds: widget.canCloseOutsideBounds,
              headerBuilder: (context, selectedItem, enabled) {
                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: widget.renderItem(selectedItem),
                      ),
                    ),
                    const Gap(4),
                    Expanded(
                      child: (widget.enable ?? false)
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  singleSelectController?.clear();
                                  widget.onChanged?.call(null);
                                  field.didChange(null);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                );
              },
              futureRequestDelay: const Duration(milliseconds: 500),
            );

          case TypeDropdown.normal:
            dropdown = CustomDropdown<T>(
              controller: singleSelectController,
              enabled: widget.enable ?? true,
              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              hintText: widget.hintText,
              hintBuilder: (context, hint, enabled) => Text(
                widget.hintText ?? 'Search value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              decoration: CustomDropdownDecoration(
                // closedErrorBorder: Border.all(
                //   color: Colors.red,
                //   width: 1,
                // ),
                closedBorderRadius: BorderRadius.circular(8),
                closedShadow: widget.showShadow
                    ? [
                        AppBoxShadow.ksSmallShadow(),
                      ]
                    : null,
              ),
              headerBuilder: (context, selectedItem, enabled) {
                return widget.renderItem(selectedItem);
              },
              items: data as List<T>, // widget.values as List<T>,
              // initialItem: _list[0],
              onChanged: (p) {
                widget.onChanged?.call(p);
              },
              listItemBuilder: widget.builderItems,
            );
            break;

          case TypeDropdown.multi_search_request:
            dropdown = CustomDropdown<T>.multiSelectSearchRequest(
              // controller: controller,
              multiSelectController: multiSelectController,
              enabled: widget.enable ?? true,
              overlayHeight: widget.overlayHeight,
              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              futureRequest: (p0) => widget.getProductFunc!(p0) as Future<List<T>>,
              hintText: widget.hintText ?? 'Search value',
              hintBuilder: (context, hint, enabled) => Text(
                widget.hintText ?? 'Search value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              // items: data,
              listItemBuilder: widget.builderItems,
              decoration: CustomDropdownDecoration(
                listItemDecoration: ListItemDecoration(
                  selectedColor: Theme.of(context).extension<ThemeColorExtension>()?.ksPrimary.withOpacity(0.2),
                ),
                closedErrorBorder: Border.all(color: Colors.red, width: 1),
                closedBorderRadius: BorderRadius.circular(8),
                closedShadow: widget.showShadow
                    ? [
                        AppBoxShadow.ksSmallShadow(),
                      ]
                    : null,
              ),

              // itemsListPadding: const EdgeInsets.only(bottom: 100),
              closeDropDownOnClearFilterSearch: true,
              canCloseOutsideBounds: widget.canCloseOutsideBounds,

              headerListBuilder: (context, selectedItem, enabled) {
                return Wrap(
                  children: List.generate(
                    selectedItem.length,
                    (index) {
                      return Container(
                        constraints: const BoxConstraints(minWidth: 1, maxWidth: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                        margin: const EdgeInsets.only(right: 12, bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.renderItem(selectedItem[index]),
                            const Gap(4),
                            if (widget.enable ?? false)
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    if (multiSelectController != null) {
                                      multiSelectController!.remove(selectedItem[index]);
                                    }
                                    widget.onListChanged?.call(
                                      multiSelectController?.value ?? [],
                                      isDelete: true,
                                    );
                                    widget.onDelete?.call(selectedItem[index]);
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            else
                              Container(),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              futureRequestDelay: const Duration(milliseconds: 500),
              onListChanged: widget.onListChanged,
            );
            break;
          case TypeDropdown.multi_search:
            dropdown = CustomDropdown<T>.multiSelect(
              multiSelectController: multiSelectController,
              enabled: widget.enable ?? true,
              overlayHeight: widget.overlayHeight,
              closedHeaderPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              hintText: widget.hintText ?? 'Search value',
              hintBuilder: (context, hint, enabled) => Text(
                widget.hintText ?? 'Search value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              listItemBuilder: widget.builderItems,
              decoration: CustomDropdownDecoration(
                listItemDecoration: ListItemDecoration(
                  selectedColor: Theme.of(context).extension<ThemeColorExtension>()?.ksPrimary.withOpacity(0.2),
                ),
                closedErrorBorder: Border.all(color: Colors.red, width: 1),
                closedBorderRadius: BorderRadius.circular(8),
                closedShadow: widget.showShadow
                    ? [
                        AppBoxShadow.ksSmallShadow(),
                      ]
                    : null,
              ),
              canCloseOutsideBounds: widget.canCloseOutsideBounds,
              headerListBuilder: (context, selectedItem, enabled) {
                return Wrap(
                  children: List.generate(
                    selectedItem.length,
                    (index) {
                      return Container(
                        constraints: const BoxConstraints(minWidth: 1, maxWidth: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                        margin: const EdgeInsets.only(right: 12, bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.renderItem(selectedItem[index]),
                            const Gap(4),
                            if (widget.enable ?? false)
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    if (multiSelectController != null) {
                                      multiSelectController!.remove(selectedItem[index]);
                                    }
                                    widget.onListChanged?.call(
                                      multiSelectController?.value ?? [],
                                      isDelete: true,
                                    );
                                    widget.onDelete?.call(selectedItem[index]);
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            else
                              Container(),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              onListChanged: widget.onListChanged,
              items: data as List<T>,
            );
          // ignore: no_default_cases
          default:
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Row(
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  const Gap(4),
                  if (widget.isRequired != null && widget.isRequired!)
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            const Gap(2),
            SizedBox(width: double.infinity, child: dropdown),
            const Gap(4),
            if (field.hasError)
              Text(
                field.errorText ?? '',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        );
      },
    );
  }
}
