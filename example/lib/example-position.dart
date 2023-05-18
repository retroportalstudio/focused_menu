import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';

class ExamplePosition extends StatelessWidget {
  const ExamplePosition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example Position')),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Long press on the card to open the menu:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            /// Bottom left (default)
            MenuItemContainer(
              text: 'Bottom left',
              description: 'default',
              backgroundColor: Colors.blue[600],
            ),

            SizedBox(height: 14),

            /// Bottom right
            MenuItemContainer(
              text: 'Bottom right',
              align: Alignment.bottomRight,
              backgroundColor: Colors.blue[700],
            ),

            SizedBox(height: 14),

            /// Bottom center
            MenuItemContainer(
              text: 'Bottom center',
              align: Alignment.bottomCenter,
              backgroundColor: Colors.blue[600],
            ),

            SizedBox(height: 14),

            /// Top left
            MenuItemContainer(
              text: 'Top left',
              description:
                  'The menu should be opened to the top left. If the menu cannot be fully displayed, it will be opened to the bottom left.',
              align: Alignment.topLeft,
              backgroundColor: Colors.deepPurple[500],
            ),

            SizedBox(height: 14),

            /// Top right
            MenuItemContainer(
              text: 'Top right',
              description:
                  'The menu should be opened to the top right. If the menu cannot be fully displayed, it will be opened to the bottom right.',
              align: Alignment.topRight,
              backgroundColor: Colors.deepPurple[700],
            ),

            SizedBox(height: 14),

            /// Bottom center
            MenuItemContainer(
              text: 'Top center',
              align: Alignment.topCenter,
              backgroundColor: Colors.deepPurple[900],
            ),

            SizedBox(height: 14),

            /// Bottom left - end of the screen
            MenuItemContainer(
              text: 'Bottom left - end of the screen',
              description:
                  'The menu should be opened to the bottom left, but because we are at the end of the screen, it will be opened to the top left.',
              align: Alignment.bottomLeft,
              backgroundColor: Colors.orange[600],
            ),

            SizedBox(height: 14),
          ],
        ),
      )),
    );
  }
}

class MenuItemContainer extends StatelessWidget {
  final String text;
  final String? description;
  final Alignment? align;
  final Color? backgroundColor;
  const MenuItemContainer({
    Key? key,
    required this.text,
    this.description,
    this.align,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      openWithTap: true,
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuOffset: 8,
      menuBoxDecoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      align: align,
      menuItems: [
        FocusedMenuItem(
          title: Text("Open"),
          trailing: Icon(Icons.open_in_new),
          onPressed: () {},
        ),
        FocusedMenuItem(
          title: Text("Share"),
          trailing: Icon(Icons.share),
          onPressed: () {},
        ),
        FocusedMenuItem(
          title: Text("Favorite"),
          trailing: Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        FocusedMenuItem(
          title: Text("Delete", style: TextStyle(color: Colors.redAccent)),
          trailing: Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
          onPressed: () {},
        ),
      ],
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: backgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              // child: Image.asset('assets/images/image_1.jpg'),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    if (description != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 12.0, left: 9, right: 9),
                        child: Text(
                          description!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
