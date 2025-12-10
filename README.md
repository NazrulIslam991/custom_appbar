# searchable_appbar

| Pub.dev | License | Platform |
| :---: | :---: | :---: |
| [![pub package](https://img.shields.io/pub/v/searchable_appbar.svg)](https://pub.dev/packages/searchable_appbar) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) | [![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev) |

A highly customizable Flutter `AppBar` widget with **built-in, animated search functionality**, automatic theme awareness, notification badges, and avatar support. Simplify your application header implementation with rich features out of the box.

---

## Features

The `searchable_appbar` is a modern replacement for Flutter's default `AppBar`, with enhanced mobile UI features:

• Integrated Search: Smooth title-to-search transition with cubic animation.  

• Live Filtering: `onChanged` & `onSearch` callbacks for real-time list updates.  

• Theme Aware: Auto adjusts text/icon color for light or dark backgrounds.  

• Notification Badge: Displays dynamic counts on action icons.  

• Profile/Avatar: Custom widget support for profile or avatar display.  

• Custom Layout: Full control of `toolbarHeight`, `bottom` widget, `bottomShape`, and `titleAlignment`.  


---

## Demo


<p align="center">
  <img src="https://github.com/user-attachments/assets/32e55d62-2183-4bbf-a588-a2de1d7b00fb"
       width="400"
       height="400"
       alt="Demo GIF">
</p>



---

## Getting started 

### Installation

## pubspec.yaml
```yaml
searchable_appbar: <lastest version>
```

2.  **Run `flutter pub get`** in your terminal.

### Prerequisites

* Flutter SDK: `>=3.0.0`
* Dart SDK: `>=2.18.0`
---

## Import
```dart
import 'package:searchable_appbar/searchable_appbar.dart';
```

## Usage 💻

### 1. Basic AppBar with Title


```dart
SearchableAppbar(
  title: "Dashboard", // AppBar title
  backgroundColor: Colors.blue, // Background color of the AppBar
)

```

### 2. AppBar with Leading Icon


```dart
SearchableAppbar(
  title: "Dashboard", // AppBar title
  leadingIcon: Icons.menu, // Leading icon (usually for drawer or back)
  onLeadingPressed: () {
    print("Menu pressed"); // Action when leading icon is pressed
  },
)


```

### 3. AppBar with Search

The search bar now automatically includes a microphone icon for voice input.

Prerequisites for Voice Search (Android & iOS): 

To enable the built-in voice search functionality, you must add the following permissions and declarations to your platform files:

1. Android (android/app/src/main/AndroidManifest.xml)
Add these lines inside the <manifest> tag, usually before the <application> tag:

```dart
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<queries>
  <intent>
    <action android:name="android.speech.action.RECOGNIZE_SPEECH" />
  </intent>
</queries>

```
2. iOS (ios/Runner/Info.plist)

Add the NSMicrophoneUsageDescription key to the main dictionary (<dict>):
```dart
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to your microphone for voice search.</string>
```

Usage Example: 

```dart
SearchableAppbar(
  title: "Search Example",
  // Callback when text is submitted (e.g., hitting Enter or finishing voice input)
  onSearch: (query) => print("Search submitted: $query"),
  
  // Callback for every keystroke or every word recognized during voice input
  onChanged: (query) => print("Current search text: $query"),
  
  hintText: "Type or tap the mic for voice search...",
  
  // Set to true if you want the search bar to stay open after submission
  keepSearchOpenAfterSubmit: true, 
)
```
AppBar with Live Filtering and Tabs: 

This example combines the use of bottom (for TabBar) and the search callbacks (onSearch/onChanged) to implement real-time list filtering within a Scaffold.

```dart
// Ensure your StatefulWidget mixins SingleTickerProviderStateMixin
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // ... (TabController and other setup)
  
  // List data and filter logic (as shown in the provided code)
  final List<String> _allItems = ["Apple", "Banana", "Carrot", ...];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    // ... (TabController initialization)
  }

  void _onSearchChanged(String query) {
    setState(() {
      final lowerCaseQuery = query.toLowerCase();
      if (lowerCaseQuery.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(lowerCaseQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchableAppbar(
        title: "Dashboard",
        leadingIcon: Icons.menu,
        notificationCount: 7,
        onChanged: _onSearchChanged, // <-- Key for live filtering
        bottom: TabBar(
          // ... (TabBar setup)
        ),
        bottomShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: TabBarView(
        // ... (TabBarView for content)
        children: [
          // Display the filtered list
          ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(_filteredItems[index]));
            },
          ),
          const Center(child: Text("Profile Content")),
          const Center(child: Text("Settings Content")),
        ],
      ),
    );
  }
}
```

### 4. AppBar with Notification Badge


```dart
SearchableAppbar(
  title: "Notifications", // AppBar title
  notificationCount: 7, // Display badge with count
  actionIconColor: Colors.white, // Color of action icons (like notifications)
)



```

### 5. AppBar with TabBar & Curved Bottom


```dart
TabController _tabController = TabController(length: 3, vsync: this); 
// TabController to control TabBar tabs

SearchableAppbar(
  title: "Dashboard", // AppBar title
  backgroundColor: Colors.blue, // AppBar color
  bottom: TabBar(
    controller: _tabController, // Connect TabBar with TabController
    tabs: const [
      Tab(text: 'Home'), // Tab 1
      Tab(text: 'Profile'), // Tab 2
      Tab(text: 'Settings'), // Tab 3
    ],
    indicator: BoxDecoration(
      color: Colors.white.withOpacity(0.3), // Indicator color
      borderRadius: BorderRadius.circular(12), // Rounded corners for indicator
    ),
    labelColor: Colors.white, // Selected tab text color
    unselectedLabelColor: Colors.white70, // Unselected tab text color
  ),
  bottomShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(16), // Curved bottom of AppBar
    ),
  ),
)

```


Properties Reference
| Name                      | Type                    | Description                                   |
| ------------------------- | ----------------------- | --------------------------------------------- |
| title                     | `String`                | AppBar title           |
| leadingIcon               | `IconData`              | Icon displayed at the leading position.       |
| onSearch                  | `ValueChanged<String>?` | Callback on search submission.                |
| onChanged                 | `ValueChanged<String>?` | Callback on every search input change.        |
| onLeadingPressed          | `VoidCallback?`         | Triggered when leading icon is pressed.       |
| toolbarHeight             | `double`                | Height of the AppBar.                         |
| titleAlignment            | `Alignment`             | Alignment of the title widget.                |
| bottomShape               | `ShapeBorder?`          | Shape applied to AppBar bottom.               |
| bottom                    | `PreferredSizeWidget?`  | Widget displayed below AppBar (e.g., TabBar). |
| backgroundColor           | `Color?`                | AppBar background color. |
| leadingIconColor          | `Color?`                | Color of the leading icon.                    |
| actionIconColor           | `Color?`                | Color of action icons.                        |
| textColor                 | `Color?`                | Color for title and search text.      |
| titleStyle                | `TextStyle?`            | Custom style for the title.                   |
| searchTextStyle           | `TextStyle?`            | Style for search input text.                  |
| hintTextStyle             | `TextStyle?`            | Style for search hint text.                   |
| leadingIconSize           | `double`                | Size of leading icon.                         |
| actionIconSize            | `double`                | Size of action icons.                         |
| notificationCount         | `int`                   | Badge count for notifications.                |
| hintText                  | `String`                | Placeholder text for search input.            |
| keepSearchOpenAfterSubmit | `bool`                  | Keeps search open after submission.           |
| searchIcon                | `IconData`              | Icon to open search mode.                     |
| closeIcon                 | `IconData`              | Icon to close search mode.                    |



---

## Additional Information ℹ️

### Reporting Issues
If you encounter any bugs or have feature requests, please feel free to **file an issue** on the [GitHub repository](https://github.com/NazrulIslam991/searchable_appbar).

### Contributing
Contributions are always welcome! You can **fork the repository**, make your improvements, and submit a **pull request**. Let’s make this package better together. 

### Version History
For a complete history of changes, bug fixes, and updates, please refer to the `CHANGELOG.md` file included in this repository.

