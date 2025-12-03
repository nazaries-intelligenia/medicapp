import 'package:flutter/material.dart';
import '../../utils/responsive_helper.dart';

/// An adaptive grid that switches between ListView (phone) and GridView (tablet+)
/// Automatically calculates column count based on screen width
class AdaptiveGrid extends StatelessWidget {
  /// The list of items to display
  final int itemCount;

  /// Builder for each item
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Minimum width for each card in grid mode (default 300)
  final double minCardWidth;

  /// Maximum columns in grid mode (default 3)
  final int maxColumns;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Spacing between items in grid mode
  final double gridSpacing;

  /// Whether to use a sliver version (for CustomScrollView)
  final bool sliver;

  /// Main axis extent for grid items (height). If null, uses childAspectRatio
  final double? itemExtent;

  /// Child aspect ratio for grid items (width/height)
  final double childAspectRatio;

  /// Physics for the scroll view
  final ScrollPhysics? physics;

  /// Whether the grid should shrink wrap
  final bool shrinkWrap;

  /// Scroll controller
  final ScrollController? controller;

  const AdaptiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minCardWidth = 300,
    this.maxColumns = 3,
    this.padding,
    this.gridSpacing = 8,
    this.sliver = false,
    this.itemExtent,
    this.childAspectRatio = 2.5,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final columns = _calculateColumns(context);

    if (sliver) {
      return _buildSliverGrid(context, columns);
    }

    // Use ListView for single column (phone), GridView for multiple columns
    if (columns == 1) {
      return _buildListView(context);
    } else {
      return _buildGridView(context, columns);
    }
  }

  int _calculateColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = (padding as EdgeInsets?)?.horizontal ?? 32;
    final availableWidth = width - horizontalPadding;
    final columns = (availableWidth / minCardWidth).floor().clamp(1, maxColumns);
    return columns;
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  Widget _buildGridView(BuildContext context, int columns) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
        mainAxisExtent: itemExtent,
        childAspectRatio: itemExtent == null ? childAspectRatio : 1,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  Widget _buildSliverGrid(BuildContext context, int columns) {
    if (columns == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
        mainAxisExtent: itemExtent,
        childAspectRatio: itemExtent == null ? childAspectRatio : 1,
      ),
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: itemCount,
      ),
    );
  }
}

/// A wrapper that constrains content to a max width and centers it
/// Useful for forms and content that shouldn't stretch too wide on tablets
class ContentContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.contentMaxWidth;

    Widget content = child;

    if (effectiveMaxWidth != null) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: child,
        ),
      );
    }

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}

/// A responsive row that switches to column on phones
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isPhone) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _addSpacing(children, vertical: true),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addSpacing(children, vertical: false),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, {required bool vertical}) {
    if (widgets.isEmpty) return widgets;

    final spacer = vertical
        ? SizedBox(height: spacing)
        : SizedBox(width: spacing);

    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(Flexible(child: widgets[i]));
      if (i < widgets.length - 1) {
        result.add(spacer);
      }
    }
    return result;
  }
}

/// A dialog wrapper that constrains max width on tablets
class ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveDialog({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.dialogMaxWidth;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: child,
      ),
    );
  }
}
