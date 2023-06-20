import 'package:chat_screen_for/home_screen.dart';
import 'package:chat_screen_for/page/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('T A B B A R'),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    color: Colors.amber,
                  ),
                ),
                Tab(
                    icon: Icon(
                  Icons.home,
                  color: Colors.amber,
                ))
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                HomeScreen(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
