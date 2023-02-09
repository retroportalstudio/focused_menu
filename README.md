<h2 align="center"> Flutter widget to create focused menu easily 🚀 </h2>

<p align="center">
  <a href="https://pub.dev/packages/focused_menu"><img src="https://img.shields.io/pub/v/focused_menu.svg" alt="Pub"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://github.com/retroportalstudio/focused_menu"><img src="https://img.shields.io/github/stars/retroportalstudio/focused_menu?style=social" alt="Pub"></a>
</p>
<p align="center">
  <a href="https://pub.dev/packages/focused_menu/score"><img src="https://img.shields.io/pub/likes/focused_menu?logo=flutter" alt="Pub likes"></a>
  <a href="https://pub.dev/packages/focused_menu/score"><img src="https://img.shields.io/pub/popularity/focused_menu?logo=flutter" alt="Pub popularity"></a>
  <a href="https://pub.dev/packages/focused_menu/score"><img src="https://img.shields.io/pub/points/focused_menu?logo=flutter" alt="Pub points"></a>
</p>

---

This is an easy to implement package for adding Focused Menu to Flutter Applications


<p float="center">
  <img src="https://github.com/retroportalstudio/focused_menu/blob/master/example/repo_files/focused_menu.gif?raw=true" width="400" />
  <img src="https://github.com/retroportalstudio/focused_menu/blob/master/example/repo_files/using-controller.gif?raw=true" width="400" /> 
  <img src="https://github.com/retroportalstudio/focused_menu/blob/master/example/repo_files/bottomToolbar.gif?raw=true" width="400" />
</p>

---

## Getting Started
Fist install the dependency

### Add dependency

```yaml
dependencies:
  focused_menu: CURRENT_VERSION
```

### Import package

```dart
import 'package:focused_menu/focused_menu.dart';
```
## Usage
To Use, simply Wrap the Widget you want to add Focused Menu to, with FocusedMenuHolder:
```dart
FocusedMenuHolder(
  menuItems: <FocusedMenuItem>[
    FocusedMenuItem(
      title: Text("This is a button"),
      trailing: Icon(Icons.open_in_new),
      onPressed: () {},
    ),
  ],
  child: CircleAvatar(
    child: Image.asset("assets/images/dp_default.png"),
  ),
),
```

---

## Customizations

In order to customize your focused menu you can change any of the available attributes

```dart
FocusedMenuHolder(
  menuOffset: 0,
  controller: _avatarController,
  animateMenuItems: true,
  blurBackgroundColor: Colors.pink,
  blurSize: 20,
  bottomOffsetHeight: 20,
  duration: Duration(milliseconds: 500),
  menuBoxDecoration:
      BoxDecoration(borderRadius: BorderRadius.circular(20)),
  menuItemExtent: 60,
  menuWidth: 200,
  openWithTap: true,
  enableMenuScroll: false,
  toolbarButtons: [
    ToolbarButtonItem(buttonIcon: Icon(Icons.delete,), onPressed: () {}, buttonIconColor: Colors.red),
    ToolbarButtonItem(buttonIcon: Icon(Icons.share), onPressed: () {}, buttonIconColor: Colors.blue),
  ],
  onOpened: () => print('Opened'),
  onClosed: () => print('onClosed'),
  onPressed: () {},
  menuItems: <FocusedMenuItem>[
    FocusedMenuItem(
      backgroundColor: Colors.green,
      title: Text("This is a button"),
      trailing: Icon(Icons.open_in_new),
      onPressed: () {},
    ),
  ],
  child: CircleAvatar(
    child: Image.asset("assets/images/dp_default.png"),
  ),
),
```

<br>
<div align="center" >
  <p>Thanks to all contributors</p>
  <a href="https://github.com/retroportalstudio/focused_menu/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=retroportalstudio/focused_menu" />
  </a>
</div>
<br>


## License
[MIT](https://choosealicense.com/licenses/mit/)
