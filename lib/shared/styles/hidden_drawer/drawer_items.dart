import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../icon_broken.dart';
import 'drawer_item.dart';

class DrawerItems {
  static const DrawerItem home = DrawerItem(
    title: 'Home',
    icon: FontAwesomeIcons.home,
  );
  static const DrawerItem chats = DrawerItem(
    icon: IconBroken.Chat,
    title: 'Chats',
  );
  static const DrawerItem post = DrawerItem(
    icon: IconBroken.Paper_Upload,
    title: 'Post',
  );
  static const DrawerItem users = DrawerItem(
    icon: IconBroken.User,
    title: 'Users',
  );
  static const DrawerItem settings = DrawerItem(
    icon: IconBroken.Paper_Upload,
    title: 'Profile',
  );
  static final List<DrawerItem> all = [
    home,
    settings,
    chats,
    users,
  ];
}
