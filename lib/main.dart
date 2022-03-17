import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:location/location.dart';

import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final map = GlobalKey<LongdoMapState>();
  final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  bool _animation = true;
  dynamic _zoomLevel;
  dynamic _min;
  dynamic _max;
  dynamic _lon;
  dynamic _lat;
  dynamic _minLon;
  dynamic _minLat;
  dynamic _maxLon;
  dynamic _maxLat;
  dynamic _rotate;
  dynamic _pitch;

  Location location = Location();
  LocationData? _location;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("WidgetsBinding");
      setState(() {});
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      print("SchedulerBinding");
      findlocation();
      setState(() {});
    });
    setState(() {});
  }

  findlocation() async {
    if (location != null) {
      location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((LocationData currentLocation) async {
        _location = await location.getLocation();
        if (_location != null) {
          print('latitude : ${_location?.latitude}');
          print('longitude : ${_location?.longitude}');
          // map.currentWidget.createElement()
          // map.currentContext.
          // map.currentState?.objectCall();
          // map.currentState?.call("Overlays.pathAnimation",[
          //    "Marker.move",
          //   {"marker" : "Marker"},
          //   {"lon": _location?.longitude, "lat": _location?.latitude},
          // ]);
          // map.currentState?.objectCall("Marker.move", [
          //   {"lon": _location?.longitude, "lat": _location?.latitude},
          // ]);
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Object? marker = map.currentState?.object(
      "Marker",
      "1",
      [
        {"lon": 102.83843421961487, "lat": 16.510321623038923},
        {
          "detail": "Edit !!!!!!!!",
          "icon": {
            "url": "https://cdn-icons-png.flaticon.com/512/1249/1249927.png",
            "size": {"width": 30, "height": 30},
            'offset': {'x': 15, 'y': 15},
          },
        },
      ],
    );

    return MaterialApp(
      scaffoldMessengerKey: messenger,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Longdo Map API3'),
        ),
        drawer: Drawer(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: ListView(
              children: [
                ListTile(
                    title: Text(
                  "Configuration",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SwitchListTile(
                  value: _animation,
                  onChanged: (it) {
                    setState(() {
                      _animation = it;
                    });
                  },
                  title: Text("Animation"),
                ),
                ListTile(
                    title: Text(
                  "MAP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                ListTile(
                    title: Text(
                  "Zoom  (1.0 to 22.0)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                ListTile(
                  title: Text("Level"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (it) {
                      _zoomLevel = it;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var zoomLevel = await map.currentState?.call("zoom");
                          messenger.currentState?.showSnackBar(
                              SnackBar(content: Text(zoomLevel)));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call("zoom", [
                            double.parse(_zoomLevel),
                            _animation,
                          ]);
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Range"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: TextField(
                            onChanged: (it) {
                              _min = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Min",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            onChanged: (it) {
                              _max = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Max",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var zoomRange =
                              await map.currentState?.call("zoomRange");
                          messenger.currentState?.showSnackBar(
                              SnackBar(content: Text(zoomRange.toString())));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call(
                            "zoomRange",
                            [
                              {
                                "min": double.parse(_min),
                                "max": double.parse(_max)
                              }
                            ],
                          );
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: TextField(
                            onChanged: (it) {
                              _lon = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Lon",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            onChanged: (it) {
                              _lat = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Lat",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var location =
                              await map.currentState?.call("location");
                          messenger.currentState?.showSnackBar(
                              SnackBar(content: Text(location.toString())));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call(
                            "location",
                            [
                              {
                                "lon": double.parse(_lon),
                                "lat": double.parse(_lat),
                                // "test": {
                                //   "test":"test"
                                // },
                              },
                              _animation,
                            ],
                          );
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: Text(
                  "Bound",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: TextField(
                            onChanged: (it) {
                              _minLon = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Min Lon",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            onChanged: (it) {
                              _minLat = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Min Lat",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: TextField(
                            onChanged: (it) {
                              _maxLon = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Max Lon",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            onChanged: (it) {
                              _maxLat = it;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Max Lat",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var bound = await map.currentState?.call("bound");
                          messenger.currentState?.showSnackBar(
                              SnackBar(content: Text(bound.toString())));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call(
                            "bound",
                            [
                              {
                                "minLon": double.parse(_minLon),
                                "minLat": double.parse(_minLat),
                                "maxLon": double.parse(_maxLon),
                                "maxLat": double.parse(_maxLat),
                              }
                            ],
                          );
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: Text(
                  "Move",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          map.currentState?.call("move", [
                            {
                              "x": 100.0,
                              "y": 0,
                            },
                            _animation,
                          ]);
                        },
                        child: Text("WEST"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call("move", [
                            {
                              "x": 0,
                              "y": 100,
                            },
                            _animation,
                          ]);
                        },
                        child: Text("SOUTH"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call("move", [
                            {
                              "x": 0,
                              "y": -100,
                            },
                            _animation,
                          ]);
                        },
                        child: Text("NORTH"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call("move", [
                            {
                              "x": -100.0,
                              "y": 0,
                            },
                            _animation,
                          ]);
                        },
                        child: Text("EAST"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: Text(
                  "Language",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var language =
                              await map.currentState?.call("language");
                          messenger.currentState
                              ?.showSnackBar(SnackBar(content: Text(language)));
                        },
                        child: Text("GET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "Rotate (Degree)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (it) {
                      _rotate = it;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var rotate = await map.currentState?.call("rotate");
                          messenger.currentState
                              ?.showSnackBar(SnackBar(content: Text(rotate)));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call(
                            "rotate",
                            [
                              _rotate,
                            ],
                          );
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "Pitch (0 to 60)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    onChanged: (it) {
                      _pitch = it;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var pitch = await map.currentState?.call("pitch");
                          messenger.currentState
                              ?.showSnackBar(SnackBar(content: Text(pitch)));
                        },
                        child: Text("GET"),
                      ),
                      TextButton(
                        onPressed: () {
                          map.currentState?.call(
                            "pitch",
                            [
                              _pitch,
                            ],
                          );
                        },
                        child: Text("SET"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "Marker",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (marker != null) {
                            map.currentState?.call("Overlays.add", [
                              marker,
                            ]);
                          }
                        },
                        child: Text("Add"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (marker != null) {
                            map.currentState?.objectCall(marker, "pop", [
                              true,
                            ]);
                          }
                        },
                        child: Text("Show"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (marker != null) {
                            map.currentState?.objectCall(marker, "pop", [
                              false,
                            ]);
                          }
                        },
                        child: Text("Hide"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            showmap(),
            Positioned(
              // padding: const EdgeInsets.all(8.0),
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                  onPressed: () async {
                    gotolocation();
                    print(marker);
                    setState(() {
                      marker;
                    });
                    if (marker != null) {
                      zoom().then((value) {
                        map.currentState?.call("location", [
                          {
                            "lon": 102.83843421961487,
                            "lat": 16.510321623038923,
                          },
                        ]);
                      });

                      map.currentState?.call("Overlays.add", [
                        marker,
                      ]);
                    }
                  },
                  child: Text('ปักหมุด')),
            ),
            Positioned(
              // padding: const EdgeInsets.all(8.0),
              bottom: 30,
              left: 10,
              child: ElevatedButton(
                  onPressed: () async {
                    // gotolocation();
                    // print(marker);
                    // setState(() {
                    //   marker;
                    // });
                    if (marker != null) {
                      // map.Route.placeholder(document.getElementById('result'));
                      // map.currentState?.call("Route.placeholder");
                      //map.Route.placeholder(document.getElementById('result'));
                      //Map({placeholder: document.getElementById('map')});
                      // map.currentWidget?.createElement();
                      map.currentContext?.describeElement("document.getElementById('result')");
                      print('1111111111111111111111111111111');
                      // map.currentState?.call("Route.placeholder", [
                      //   {"document.getElementById": "result"}
                      // ]);
                      map.currentState?.call("Route", [
                        {"placeholder": "document.getElementById('map')"}
                      ]);
                      print('2222222222222222222222222222222');
                      map.currentState?.call("Route.add", [
                        {
                          "lon": 102.83914888516223,
                          "lat": 16.510553891600814,
                        },
                      ]);
                      print('3333333333333333333333333333333');
                      map.currentState?.call("Route.add", [
                        {
                          "lon": 102.83122731601415,
                          "lat": 16.466249511152856,
                        },
                      ]);
                      map.currentState?.call("Route.search");

                      // zoom().then((value) {
                      //   map.currentState?.call("location", [
                      //     {
                      //       "lon": 102.83843421961487,
                      //       "lat": 16.510321623038923,
                      //     },
                      //   ]);
                      // });

                      // map.currentState?.call("Overlays.add", [
                      //   marker,
                      // ]);
                    }
                  },
                  child: Text('นำทางไปศูนย์หัวใจ')),
            ),
            Positioned(
              // padding: const EdgeInsets.all(8.0),
              bottom: 70,
              left: 10,
              child: ElevatedButton(
                  onPressed: () async {
                    // gotolocation();
                    // print(marker);
                    // setState(() {
                    //   marker;
                    // });
                    if (marker != null) {
                      // map.Route.placeholder(document.getElementById('result'));
                      // map.currentState?.call("Route.placeholder");
                      //map.Route.placeholder(document.getElementById('result'));
                      // print('1111111111111111111111111111111');
                      // map.currentState?.call("Route.placeholder", [
                      //   {"document.getElementById": "result"}
                      // ]);
                      // print('2222222222222222222222222222222');
                      // map.currentState?.call("Route.add", [
                      //   {
                      //     "lon": 102.83914888516223,
                      //     "lat": 16.510553891600814,
                      //   },
                      // ]);
                      // print('3333333333333333333333333333333');
                      // map.currentState?.call("Route.add", [
                      //   {
                      //     "lon": 102.83122731601415,
                      //     "lat": 16.466249511152856,
                      //   },
                      // ]);
                      // map?.run(script: "map.Route.clearDestination()");
                      // map?.run(script: "map.Route.clear()");

                      map.currentState?.call("Route.clear");

                      // zoom().then((value) {
                      //   map.currentState?.call("location", [
                      //     {
                      //       "lon": 102.83843421961487,
                      //       "lat": 16.510321623038923,
                      //     },
                      //   ]);
                      // });

                      // map.currentState?.call("Overlays.add", [
                      //   marker,
                      // ]);
                    }
                  },
                  child: Text('ยกเลิกการทำทาง')),
            ),
          ],
        ),
      ),
    );
  }

// 16.466249511152856, 102.83122731601415
  LongdoMapWidget showmap() {
    return LongdoMapWidget(
      apiKey: "65a993de20d4de36417758d88f094ccf",
      key: map,
    );
  }

  Future<void> zoom() async {
    await map.currentState?.call("zoom", [
      17,
      _animation,
    ]);
    Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  gotolocation() {}
  void onInit(LongdoMapState map) {
    setState(() {});
    print('awpdokowkdopakdojnasdnjawndla;owdoa');
    map.call(
      "location",
      [
        {
          "lon": 102.83843421961487,
          "lat": 16.510321623038923,
        },
        _animation,
      ],
    );
  }

  void test() {
    print('test init !!');
  }
}
