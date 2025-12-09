# custom_appbar 🚀

| Pub.dev | License | Platform |
| :---: | :---: | :---: |
| [![pub package](https://img.shields.io/pub/v/custom_appbar.svg)](https://pub.dev/packages/custom_appbar) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) | [![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev) |

A highly customizable Flutter `AppBar` widget with **built-in, animated search functionality**, automatic theme awareness, notification badges, and avatar support. Simplify your application header implementation with rich features out of the box.

---

## Features ✨

The `CustomAppBar` is designed to be a drop-in replacement for `AppBar`, offering enhanced capabilities for modern mobile applications:

* **Integrated Search:** Seamless transition between the title and a full-width **search text field** using a smooth cubic animation.
* **Live Filtering Support:** Provides dedicated `onChanged` and `onSearch` callbacks for implementing real-time list filtering.
* **Theme Awareness:** Automatically determines the appropriate text and icon colors (**White** for Dark/Colored backgrounds, **Black** for Light backgrounds) unless explicitly overridden.
* **Notification Badge:** Easily display dynamic, non-intrusive **notification counts** directly on the action icon.
* **Profile/Avatar Button:** Supports custom `Widget` for a profile picture or avatar in the actions list.
* **Customizable Layout:** Full control over `toolbarHeight`, `bottom` widget (e.g., `TabBar`), `bottomShape`, and `titleAlignment`.



---

## Getting started 📦

### Installation

1.  **Add the dependency** to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      custom_appbar: ^0.1.0
    ```

2.  **Run `flutter pub get`** in your terminal.

### Prerequisites

* Flutter SDK: `>=3.0.0`
* Dart SDK: `>=2.18.0`

---

## Usage 💻

### 1. Basic Implementation (Search & Filtering)

To integrate the app bar and enable live search filtering on your list data, use the `onChanged` property:

```dart
import 'package:flutter/material.dart';
import 'package:custom_appbar/custom_appbar.dart'; // Assuming your custom class is here

class HomeScreen extends StatefulWidget {
  // ...
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> allItems = ['Apple', 'Banana', 'Cherry', 'Date'];
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }
  
  // 💡 This function updates the list in real-time
  void onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = allItems;
      } else {
        filteredItems = allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Product Catalog",
        hintText: "Search fruits...",
        onChanged: onSearchChanged, // Passes query for live filtering
        keepSearchOpenAfterSubmit: true, // Keep search field active after hitting enter
        backgroundColor: Colors.deepPurple,
        notificationCount: 5,
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(filteredItems[index]));
        },
      ),
    );
  }
}

You can easily integrate a TabBar by utilizing the bottom property, and customize the look and feel using various style properties.
// Example of using CustomAppBar with a TabBar
CustomAppBar(
  title: "Advanced Dashboard",
  titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  toolbarHeight: 65.0,
  backgroundColor: Theme.of(context).primaryColor,
  
  // Custom Icon/Text Colors
  leadingIconColor: Colors.yellow,
  actionIconColor: Colors.yellow,
  
  // Profile Avatar and Notification Badge
  notificationCount: 99, 
  profileAvatar: const CircleAvatar(
    radius: 12,
    child: Text('U'),
  ),
  onProfileMenuSelected: (value) => print('Profile button tapped'),

  // Custom Bottom Widget (TabBar)
  bottom: const TabBar(
    tabs: [
      Tab(text: 'Feed'), 
      Tab(text: 'Messages')
    ],
  ),
  // Custom Shape for the AppBar
  bottomShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
  ),
),


Properties Reference
| Name | Type | Default | Description |
|------|------|---------|-------------|
| title | String | "App Title" | The title text displayed when search is closed. |
| leadingIcon | IconData | Icons.menu | The icon displayed at the leading position. |
| onChanged | ValueChanged<String>? | null | Callback triggered whenever the search text changes (for live filtering). |
| onSearch | ValueChanged<String>? | null | Callback triggered when the user submits the search (e.g., presses Enter). |
| onLeadingPressed | VoidCallback? | null | Callback invoked when the leading icon is pressed. |
| toolbarHeight | double | kToolbarHeight | Height of the AppBar toolbar. |
| titleAlignment | Alignment | Alignment.centerLeft | Alignment of the title widget. |
| bottomShape | ShapeBorder? | null | Shape applied to the bottom of the AppBar. |
| bottom | PreferredSizeWidget? | null | Widget displayed below the AppBar (e.g., TabBar). |
| backgroundColor | Color? | Theme-aware | Background color of the AppBar. |
| leadingIconColor | Color? | Theme-aware | Color of the leading icon. |
| actionIconColor | Color? | Theme-aware | Color of action icons (search, profile, notifications). |
| textColor | Color? | Theme-aware | Default text color for title and search text. |
| titleStyle | TextStyle? | null | TextStyle applied to the title. |
| searchTextStyle | TextStyle? | null | TextStyle applied to the search TextField. |
| hintTextStyle | TextStyle? | null | TextStyle applied to the search hint text. |
| leadingIconSize | double | 24.0 | Size of the leading icon. |
| actionIconSize | double | 24.0 | Size of action icons. |
| profileAvatar | Widget? | null | Custom widget (e.g., CircleAvatar) displayed as profile button. |
| popupMenuItems | List<PopupMenuEntry>? | null | List of menu items for profile/action menu. |
| onProfileMenuSelected | ValueChanged<dynamic>? | null | Callback when a profile menu item is selected. |
| notificationCount | int | 0 | Number displayed in red badge for notifications. |
| hintText | String | "Search..." | Placeholder text for the search field. |
| keepSearchOpenAfterSubmit | bool | false | Whether to keep the search bar open after pressing submit. |
| searchIcon | IconData | Icons.search | Icon displayed to open search mode. |
| closeIcon | IconData | Icons.close | Icon displayed to close search mode. |

"

Additional information ℹ️
Reporting Issues: If you encounter any bugs or have feature requests, please file an issue on the GitHub repository.

Contributing: Contributions are welcome! Feel free to fork the repository and submit a pull request.

Version History: See the CHANGELOG.md for a complete history of changes.
