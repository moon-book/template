// import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TreeNodeExt extends Equatable {
  TreeNodeExt({
    required this.name,
    this.pathRouter,
    this.icon,
    this.parentPathRouter,
    this.parent,
    this.children = const [],
  });
  String? pathRouter;
  String? parentPathRouter;
  Widget? icon;
  String name;
  TreeNodeExt? parent;
  List<TreeNodeExt> children;
  @override
  List<Object?> get props => [
        pathRouter,
        parentPathRouter,
        icon,
        name,
        parent,
      ];
}
