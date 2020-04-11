import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hypergaragesale/components/icon_content.dart';
import 'package:hypergaragesale/components/reusable_card.dart';
import 'package:hypergaragesale/components/rounded_button.dart';
import 'package:hypergaragesale/screens/item_list_screen.dart';
import 'package:hypergaragesale/screens/post_screen.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category_screen';
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'unselected';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.lightBlueAccent,
        title: Text('  Category'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'electronics',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.laptop,
                            label: 'Electronics'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'electronics';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'tools',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.tools, label: 'Tools'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'tools';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'clothes',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.tshirt, label: 'Clothes'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'clothes';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'books',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.book, label: 'Books'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'books';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'furnitures',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.couch, label: 'Furnitures'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'furnitures';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ReusableCard(
                        choose: selectedCategory == 'toys',
                        childIcon: IconContent(
                            icon: FontAwesomeIcons.plane, label: 'Toys'),
                        onPress: () {
                          setState(() {
                            selectedCategory = 'toys';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Go Treasure Hunt',
                onPressed: () {
                  if (selectedCategory == 'unselected') {
                    noCategoryNotification(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemListScreen(category: selectedCategory),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 5.0),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Make a New Post',
                onPressed: () {
                  if (selectedCategory == 'unselected') {
                    noCategoryNotification(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostScreen(category: selectedCategory),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void noCategoryNotification(context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => SingleChildScrollView(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          Text(
            'Please Select a Category!',
            style: TextStyle(fontSize: 22.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          FlatButton(
            color: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Text(
              'OK',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
