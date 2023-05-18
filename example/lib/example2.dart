import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';

class Example2 extends StatefulWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  FocusedMenuHolderController _avatarController = FocusedMenuHolderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Using controller'),
        actions: [
          FocusedMenuHolder(
            menuOffset: 0,
            controller: _avatarController,
            onPressed: () {},
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
          SizedBox(width: 20)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => _avatarController.open(),
              child: Text('Open avatar menu'),
            ),
          ),
        ],
      ),
    );
  }
}
