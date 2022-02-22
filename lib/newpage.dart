import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newweather/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Newpage extends StatefulWidget {
  const Newpage({Key? key}) : super(key: key);

  @override
  _NewpageState createState() => _NewpageState();
}

class _NewpageState extends State<Newpage> {
  TextEditingController city = TextEditingController();
  var cityName = "ferozepur";

  getSharedCity() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("city") != null) {
      cityName = shared.getString("city")!;
      // var a = shared.getString("country");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303644),
      appBar: AppBar(
        backgroundColor: Color(0xff303644),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text("cancel")),
                        ),
                        GestureDetector(
                          onTap: () {
                            cityName = city.text;
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("ok"),
                          ),
                        ),
                      ],
                      content: TextField(
                        controller: city,
                        decoration: InputDecoration(
                          hintText: "Enter City Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    );
                  }).whenComplete(() {
                setState(() {
                  print(cityName);
                });
              });
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
              future: getCity(cityName),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data;
                print(data);
                if (data.isEmpty) {
                  return Center(
                    child: Text("City Not Found"),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        cityName,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Today",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.network(
                        "http://openweathermap.org/img/wn/" +
                            data["current"]["weather"][0]["icon"] +
                            "@4x.png",
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        "${data["current"]["temp"]}°",
                        style: TextStyle(color: Colors.white, fontSize: 85),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        data["current"]["weather"][0]["description"].toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "L:" +
                                data["daily"][0]["temp"]["min"].toString() +
                                "° ",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "H:" +
                                data["daily"][0]["temp"]["max"].toString() +
                                "°",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: data["daily"].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    index == 0
                                        ? Container(
                                            width: 70, child: Text("Today"))
                                        : Container(
                                            width: 70,
                                            child: Text(DateFormat("EE")
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                  data["daily"][index]["dt"] *
                                                      1000,
                                                ))
                                                .toString()),
                                          ),
                                    Image.network(
                                      "http://openweathermap.org/img/wn/" +
                                          data["daily"][index]["weather"][0]
                                              ["icon"] +
                                          ".png",
                                      width: 30.0,
                                      // color: Colors.white,
                                    ),
                                    Spacer(),
                                    Text(data["daily"][index]["temp"]["min"]
                                            .floor()
                                            .toString() +
                                        "°"),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Text(data["daily"][index]["temp"]["max"]
                                            .floor()
                                            .toString() +
                                        "°")
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }),
        ),
      )),
    );
  }
}
