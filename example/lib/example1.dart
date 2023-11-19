import 'package:example/ScreenTwo.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';

class Example1 extends StatefulWidget {
  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Music Albums",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Center()),
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Look for your Interest!",
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                    .map((e) => FocusedMenuHolder(
                          menuWidth: MediaQuery.of(context).size.width * 0.50,
                          blurSize: 5.0,
                          menuItemExtent: 45,
                          menuBoxDecoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          itemsCardBorderRadius:
                              BorderRadius.all(Radius.circular(5)),
                          duration: Duration(milliseconds: 100),
                          animateMenuItems: true,
                          blurBackgroundColor: Colors.black54,
                          bottomOffsetHeight: 100,
                          openWithTap: false,
                          enableMenuScroll: false,
                          toolbarActions: [
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () {},
                                color: Colors.red),
                            IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {},
                                color: Colors.blue),
                          ],
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(
                                title: Text("Open"),
                                trailing: Icon(Icons.open_in_new),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScreenTwo()));
                                }),
                            FocusedMenuItem(
                                title: Text("Share"),
                                trailing: Icon(Icons.share),
                                onPressed: () {}),
                            FocusedMenuItem(
                                title: Text("Favorite"),
                                trailing: Icon(Icons.favorite_border),
                                onPressed: () {}),
                            FocusedMenuItem(
                                title: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                trailing: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {}),
                          ],
                          onPressed: () {},
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Image.asset("assets/images/image_$e.jpg"),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Menu 2"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Menu 3"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Menu 4"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Menu 5"),
      ]),
    );
  }
}
