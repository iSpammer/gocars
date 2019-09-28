import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarPictureDisplay.dart';
import 'package:gocars/util/data.dart';
import 'package:gocars/widgets/badge.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarsDetailPage extends StatefulWidget {
  final int carId;

  CarsDetailPage({Key key, @required this.carId}) : super(key: key);

  @override
  _CarsDetailPageState createState() => _CarsDetailPageState();
}

class _CarsDetailPageState extends State<CarsDetailPage> {
  Future<bool> _saveFavList(int carUid) async {
    print("favs 1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = (prefs.getStringList('fav') ?? List<String>());
    List<int> list = temp.map((i) => int.parse(i)).toList();
    print("asddd $list");
    if (list == null) {
      return prefs.setStringList("fav", ["$carUid"]);
    } else {
      list.add(carUid);
      List<String> temp2 = list.map((i) => i.toString()).toList();
      return await prefs.setStringList("fav", temp2);
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < cars.length; i++) {
      if (cars[i]['uid'] == widget.carId) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "${cars[widget.carId]["name"]}",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: IconBadge(
                  icon: Icons.shopping_basket,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          body: Stack(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return CarPictureDisplay(
                                      picturePath: cars[i]["img"],
                                    );
                                  },
                                ),
                              );
                            },
                            child: Image.asset(
                              "${cars[i]["img"]}",
                              height: 240,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10.0,
                          bottom: 3.0,
                          child: RawMaterialButton(
                            onPressed: () {},
                            fillColor: Colors.white,
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () {
                                  print("favs ${(cars[i]["uid"])}");
                                  _saveFavList(cars[i]["uid"]);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).accentColor,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${cars[i]["name"]}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$550.00",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    cars[i]['description'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Photos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: cars[widget.carId]['otherImg'].length,
                      itemBuilder: (BuildContext context, int index) {
                        String carpic = cars[widget.carId]['otherImg'][index];
                        print("$carpic asd");
                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              print("$carpic");
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return CarPictureDisplay(
                                      picturePath: carpic,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "$carpic",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Other Cars",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: cars.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map car = cars.toList()[index];
                        if (widget.carId != car['uid']) {
                          return Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (BuildContext context) {
                                      return CarsDetailPage(
                                        carId: car['uid'],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    "${car["img"]}",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).accentColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange[200],
                          offset: Offset(0.0, 10.0),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
