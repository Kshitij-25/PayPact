import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import '../../core/constants/theme_constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelectedIndex,
  });
  final int currentIndex;
  final ValueChanged<int> onSelectedIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  final List<IconData> icons = [
    CupertinoIcons.house_fill,
    CupertinoIcons.person_2_fill,
    // CupertinoIcons.add,
    CupertinoIcons.graph_square,
    CupertinoIcons.person_fill,
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final iconSlotWidth = (MediaQuery.of(context).size.width - 40) / icons.length;

    final themeConstants = ThemeConstants(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: themeConstants.isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: themeConstants.lightShadow,
                blurRadius: 5,
                offset: Offset(2.5, 2.5),
                inset: false,
              ),
              BoxShadow(
                color: themeConstants.shadowColor,
                blurRadius: 5,
                offset: Offset(-2.5, -2.5),
                inset: false,
              ),
            ],
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: selectedIndex,
            builder: (context, index, child) {
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: (selectedIndex.value * iconSlotWidth) + ((iconSlotWidth - 50) / 2),
                    bottom: 10,
                    child: iconContainer(
                      true,
                      themeConstants.lightShadow,
                      themeConstants.shadowColor,
                      themeConstants.isDarkMode,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          icons.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(top: 21),
                            child: GestureDetector(
                              onTap: () {
                                if (index != widget.currentIndex) {
                                  selectedIndex.value = index;
                                  widget.onSelectedIndex.call(index);
                                }
                              },
                              child: Icon(
                                icons[index],
                                size: 28,
                                color: selectedIndex.value == index
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryFixedVariant
                                    : Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget iconContainer(
    bool inset,
    Color lightShadow,
    Color shadowColor,
    bool isDarkMode,
  ) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).cardColor : const Color(0xFFE7EBF0),
        borderRadius: BorderRadius.circular(50),
        boxShadow: inset
            ? [
                BoxShadow(
                  color: lightShadow,
                  blurRadius: 5,
                  offset: Offset(2.5, 2.5),
                  inset: true,
                ),
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 5,
                  offset: Offset(-2.5, -2.5),
                  inset: true,
                ),
              ]
            : [],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
