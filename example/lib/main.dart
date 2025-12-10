import 'package:flutter/material.dart';
import 'package:searchable_appbar/searchable_appbar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom AppBar Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // TabController for controlling TabBar
  late TabController _tabController;

  // Define the tabs
  final List<Tab> myTabs = const [
    Tab(text: "Home"),
    Tab(text: "Profile"),
    Tab(text: "Settings"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function called when search is submitted
  void _onSearchSubmitted(String query) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Search: $query')));
  }

  // Function called when search text changes
  void _onSearchChanged(String query) {
    // You can filter content here
  }

  // Function called when profile button is pressed
  void _onProfileSelected(dynamic value) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile button clicked')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CustomAppBar with all features
      appBar: SearchableAppbar(
        title: "Dashboard", // Title of AppBar
        leadingIcon: Icons.menu, // Leading icon
        backgroundColor: Colors.blue, // AppBar color
        notificationCount: 7, // Notification badge count
        profileAvatar: const CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white,
          child: Text('P', style: TextStyle(color: Colors.blue)),
        ), // Profile avatar
        onProfileMenuSelected: _onProfileSelected, // Profile click action
        onSearch: _onSearchSubmitted, // Search submit callback
        onChanged: _onSearchChanged, // Search text change callback
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          labelColor: Colors.white, // Selected tab text color
          unselectedLabelColor: Colors.white70, // Unselected tab text color
        ),
        bottomShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // Curve radius at bottom
          ),
        ),
      ),

      // TabBarView for displaying content of each tab
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text("Home Content")), // Home tab content
          Center(child: Text("Profile Content")), // Profile tab content
          Center(child: Text("Settings Content")), // Settings tab content
        ],
      ),
    );
  }
}
