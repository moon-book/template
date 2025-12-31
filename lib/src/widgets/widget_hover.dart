import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:template/template.dart';

///nếu dùng hãy bọc Portal của  flutter_portal: ^1.1.4 vào widget cha của nó
class WidgetHoverShowInfo<T> extends StatefulWidget {
  WidgetHoverShowInfo({
    super.key,
    required this.child,
    required this.data,
    required this.buildInfo,
    this.aligned,
  });
  T data;
  Widget child;
  final Widget Function(T data) buildInfo;
  final Aligned? aligned;
  @override
  State<WidgetHoverShowInfo> createState() => _WidgetHoverShowInfoState<T>();
}

class _WidgetHoverShowInfoState<T> extends State<WidgetHoverShowInfo<T>> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: PortalTarget(
        visible: _showTooltip,

        // fit: StackFit.expand,
        anchor: widget.aligned ??
            Aligned(
              follower: Alignment.topCenter, // Tooltip nằm dưới item
              target: Alignment.bottomCenter,
              // widthFactor: 1,
              // offset: widget.aligned ?? Offset.zero, // Offset(-36, 0),
            ),
        portalFollower: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              onExit: (_) => setState(() => _showTooltip = false),
              onEnter: (_) => setState(() => _showTooltip = true),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        AppBoxShadow.ksSmallShadow(),
                      ],
                    ),
                    child: widget.buildInfo(widget.data),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _showTooltip = true),
          onExit: (_) => setState(() => _showTooltip = false),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
