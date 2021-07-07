import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/constants.dart';
import 'hidden_drawer/drawer_item.dart';
import 'hidden_drawer/drawer_items.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late double xOffset = 230;
  late double yOffset = 150;
  late double scaleFactor = 0.6;
  late bool isDrawerOpen = false;
  bool isDragging = false;
  DrawerItem currentItem = DrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() => setState(() {
        xOffset = 230;
        yOffset = 150;
        scaleFactor = 0.6;
        isDrawerOpen = true;
      });

  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildDrawerItem(context),
          buildPage(),
        ],
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: DrawerItems.all
                .map(
                  (item) => ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    leading: Icon(
                      item.icon,
                      color: Colors.black,
                    ),
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      setState(() {
                        currentItem = item;
                        closeDrawer();
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
      );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta)
            openDrawer();
          else if (details.delta.dx < -delta) closeDrawer();
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Card(
                color: !isDrawerOpen ? Colors.white12 : primaryColor,
                child: selectScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectScreen() {
    // switch (currentItem) {
    //   case DrawerItems.home:
    //     return FeedsScreen(openDrawer: openDrawer);
    //   case DrawerItems.settings:
    //     return SettingsScreen(openDrawer: openDrawer);
    //   case DrawerItems.users:
    //     return UsersScreen(openDrawer: openDrawer);
    //   case DrawerItems.chats:
    //     return ChatsScreen(openDrawer: openDrawer);
    //   default:
    //     return SettingsScreen(openDrawer: openDrawer);
    return Container();
  }
}
