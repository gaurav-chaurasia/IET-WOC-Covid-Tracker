import 'package:covid_tracker/screens/drawer_screen.dart';
import 'package:covid_tracker/screens/home_subscreens/health_status.dart';
import 'package:covid_tracker/screens/home_subscreens/covid_map.dart';
import 'package:covid_tracker/screens/home_subscreens/covid_updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  MotionTabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _tabController = new MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InkWell(
            onTap: () => _openDrawer(),
            child: Row(
              children: [
                Icon(Icons.settings),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Covid Tracker",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).pushNamed('/notifications');
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: MotionTabBarView(
        children: [
          HealthStatus(),
          CovidMap(),
          CovidUpdates(),
        ],
        controller: _tabController,
      ),
      bottomNavigationBar: MotionTabBar(
        labels: ["Your Status", "Covid Map", "Covid Updates"],
        initialSelectedTab: "Covid Map",
        tabIconColor: Colors.green,
        tabSelectedColor: Colors.red,
        onTabItemSelected: (int value) {
          print(value);
          setState(() {
            _tabController.index = value;
          });
        },
        icons: [
          FontAwesome.heartbeat,
          FontAwesome.map_marker,
          FontAwesome.bar_chart
        ],
        textStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
