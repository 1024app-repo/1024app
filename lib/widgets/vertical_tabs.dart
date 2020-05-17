import 'package:flutter/material.dart';

enum IndicatorSide { start, end }

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final Key key;
  final int initialIndex;
  final double tabsWidth;
  final double indicatorWidth;
  final IndicatorSide indicatorSide;
  final List<Tab> tabs;
//  final List<Widget> contents;
  final TextDirection direction;
  final Color indicatorColor;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color selectedTabBackgroundColor;
  final Color tabBackgroundColor;
  final TextStyle selectedTabTextStyle;
  final TextStyle tabTextStyle;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function(int tabIndex) onSelect;
  final Color backgroundColor;

  VerticalTabs(
      {this.key,
      @required this.tabs,
      this.tabsWidth = 200,
      this.indicatorWidth = 3,
      this.indicatorSide,
      this.initialIndex = 0,
      this.direction = TextDirection.ltr,
      this.indicatorColor = Colors.green,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.horizontal,
      this.selectedTabBackgroundColor = const Color(0xFFf2f2f2),
      this.tabBackgroundColor = Colors.white,
      this.selectedTabTextStyle = const TextStyle(color: Colors.black),
      this.tabTextStyle = const TextStyle(color: Colors.black),
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.tabsShadowColor = Colors.black54,
      this.tabsElevation = 2.0,
      this.onSelect,
      this.backgroundColor})
      : assert(tabs != null),
        super(key: key);

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        child: ListView.separated(
          itemCount: widget.tabs.length,
          itemBuilder: (context, index) {
            Tab tab = widget.tabs[index];

            Alignment alignment = Alignment.center;
            Widget child;
            if (tab.child != null) {
              child = tab.child;
            } else {
              child = Container(
                padding: EdgeInsets.all(0),
                child: Container(
                  child: Text(tab.text),
                ),
              );
            }

            Color itemBGColor = Theme.of(context).backgroundColor;
            if (_selectedIndex == index)
              itemBGColor = Theme.of(context).canvasColor;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectTab(index);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: itemBGColor,
                ),
                alignment: alignment,
                padding: EdgeInsets.all(12),
                child: child,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
//            color: Color(0xFF808080),
            thickness: 0.6,
            height: 0,
          ),
        ),
      ),
    );
  }

  void _selectTab(index) {
    _selectedIndex = index;

    if (widget.onSelect != null) {
      widget.onSelect(_selectedIndex);
    }
  }
}
