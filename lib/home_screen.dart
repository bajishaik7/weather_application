import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController c_controller = TextEditingController();
  var location = {};
  var current = {};
  String _condition = "";
  bool search = false;
  String city = "hyderabad";
  Future getData() async {
    var resp = await http.get(Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=9733c54a37904e92ab3104842231707&q=${city}&aqi=no"));

    if (resp.statusCode == 200) {
      var skb = jsonDecode(resp.body);

      setState(() {
        location = skb["location"];
        current = skb["current"];
        _condition = current["condition"]["text"];
      });
    } else {
      throw Text("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Are you sure ?"),
                  content: Text("Do you want to exit this App"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          // SystemNavigator.pop();
                        },
                        child: Text("Yes")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("No"))
                  ],
                )));
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: location.isNotEmpty
              ? ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // color: Colors.amber,
                        gradient: LinearGradient(
                            stops: [0.2, 0.85],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xff955cd1), Color(0xff3fa2fa)]),
                      ),
                      margin: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 50,
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextFormField(
                                controller: c_controller,
                                onChanged: (value) {
                                  setState(() {
                                    search = true;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "Search City",
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          search = false;
                                          setState(() {
                                            city = c_controller.text;
                                          });
                                          getData();
                                          c_controller.clear();
                                        },
                                        icon: Icon(Icons.search),
                                        color: search == true
                                            ? Colors.blue
                                            : Colors.black),
                                    // border: InputBorder.none,
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black87),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                            ),

                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                textw(
                                  s: "${location["name"]}",

                                  fsize: 35,
                                  color: Colors.white,
                                  // gf: GoogleFonts.hubballi,
                                ),
                                textw(
                                  s: "${DateTime.now()}".substring(0, 10),
                                  fsize: 16,
                                  color: Colors.white,
                                ),
                                Container(
                                    // color: Colors.amber,
                                    height: 140,
                                    width: 140,
                                    child: _condition.contains("rain")
                                        ? LottieBuilder.asset(
                                            "assets/rain.json")
                                        : _condition.contains("Cloud")
                                            ? LottieBuilder.asset(
                                                "assets/cloud.json")
                                            : _condition.contains("Sunny")
                                                ? LottieBuilder.asset(
                                                    "assets/sunny.json")
                                                : _condition
                                                        .contains("Overcast")
                                                    ? LottieBuilder.asset(
                                                        "assets/overcast.json")
                                                    : _condition
                                                            .contains("Mist")
                                                        ? LottieBuilder.asset(
                                                            "assets/mist.json")
                                                        : _condition.contains(
                                                                "Clear")
                                                            ? LottieBuilder.asset(
                                                                "assets/clear.json")
                                                            : Image.network(
                                                                "https:${current["condition"]["icon"]}",
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                    /*  Image.network(
                                  "https:${Details1["condition"]["icon"]}",
                                  fit: BoxFit.fill,
                                ) */
                                    ),
                                Container(
                                  // color: Colors.amber,
                                  child: Center(
                                    child: textw(
                                      s: "$_condition",
                                      fsize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            textw(
                              s: "${current["temp_c"]}°",
                              fsize: 45,
                              color: Colors.white,
                            ),
                            //https://cdn.weatherapi.com/weather/64x64/night/113.png
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: LottieBuilder.asset(
                                              "assets/wind.json")),
                                      textw(
                                        s: "${current["wind_kph"]} km/h",
                                        fsize: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      textw(
                                        s: "Wind",
                                        fsize: 17,
                                        color: Colors.white54,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: LottieBuilder.asset(
                                              "assets/humidity.json")),
                                      // Text("${Details1["humidity"]}"),
                                      textw(
                                        s: "${current["humidity"]}",
                                        fsize: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      textw(
                                        s: "Humidity",
                                        fsize: 17,
                                        color: Colors.white54,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: LottieBuilder.asset(
                                              "assets/direction.json")),
                                      textw(
                                        s: "${current["wind_dir"]}",
                                        fsize: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      textw(
                                        s: "Wind Direction",
                                        fsize: 17,
                                        color: Colors.white54,
                                      ),
                                    ],
                                  ),
                                  /* 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [Text("fg"), Text("fg"), Text("fg")],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("${Details1["wind_kph"]}km/hr"),
                                  Text("${Details1["humidity"]}"),
                                  Text("${Details1["wind_dir"]}")
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Wind"),
                                  Text("Humidity"),
                                  Text("Wind Direction")
                                ],
                              ),
                            */
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            textw(
                              s: "Gust",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["gust_kph"]} kph",
                              fsize: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            textw(
                              s: "Pressure",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["pressure_mb"]} kph",
                              fsize: 18,
                              color: Colors.white,
                            ),
                          ]),
                          Column(children: [
                            textw(
                              s: "Uv",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["uv"]}",
                              fsize: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            textw(
                              s: "Percipitation",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["precip_mm"]} mm",
                              fsize: 18,
                              color: Colors.white,
                            ),
                          ]),
                          Column(children: [
                            textw(
                              s: "Gust",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["gust_kph"]} kph",
                              fsize: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            textw(
                              s: "Updated On",
                              fsize: 15,
                              color: Colors.white54,
                            ),
                            textw(
                              s: "${current["last_updated"]}".substring(0, 11),
                              fsize: 18,
                              color: Colors.white,
                            ),
                          ])
                        ],
                      ),
                    )
                  ],
                )

              // }))
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class textw extends StatelessWidget {
  textw({
    super.key,
    this.s,
    this.color,
    this.fsize,
  });
  String? s;
  Color? color;
  double? fsize;
  // GoogleFonts gf;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$s",
      style: TextStyle(
        color: color,
        fontSize: fsize,
      ),
    );
  }
}
