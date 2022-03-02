import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:longdo_maps_flutter/longdo_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:test_maps/Dio.dart';
import 'package:test_maps/model/LocationDataLodel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}
void onStart() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.sendData(
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}


class MyApp extends StatefulWidget {
  @override
  State createState() => _MyAppState();
}

class AppTheme {
  static final DATA = ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.black87,
      scaffoldBackgroundColor: Colors.white);
}

class _MyAppState extends State<MyApp> implements MapInterface {
  // STEP 1 : Get a Key API
  // https://map.longdo.com/docs/javascript/getting-started
  static const API_KEY = "65a993de20d4de36417758d88f094ccf";
  MapController? map;
  LongdoMapView? longdoMap;

  bool? routing = false;

  List<Marker> markers = [];
  final global = GlobalKey<ScaffoldState>();
  bool thaiChote = false;
  bool traffic = false;
  Location location = Location();
  LocationData? _location;
  int i = 0;
  int j = 0;
  LocationDataModel? locationDataModel;
  List<dynamic>? dataAllLocation;
  List<LocationDataModel>? dataforshow = [];

  @override
  void initState() {
    super.initState();
    findlocation();
    showdata();
    

    //  WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   showsheet(context);
    // });
  }

  findlocation() async {
    if (location != null) {
      location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((LocationData currentLocation) async {
        j++;
        print(j);
        _location = await location.getLocation();
        if (_location != null) {
          var params = {
            "latitude": _location?.latitude,
            "longitude": _location?.longitude,
          };
          print('latitude : ${_location?.latitude}');
          print('longitude : ${_location?.longitude}');
          // post(context, 'api/location/store', params)
          //     .then((value) => print(value));
          map?.run(
              script:
                  "yourlocation.move({lon: ${_location?.longitude}, lat: ${_location?.latitude}}, true)");
          if (routing == true) {
            setState(() {
              i++;
            });
            final script =
                '''map.Route.exportRouteLine().distance({lat: ${_location?.latitude} ,lon:${_location?.longitude}})''';
            var value = await map?.run(script: script);

            if (value <= 60.00) {
            } else {
              print('more ! 60 matre');
              print('100 matre');
              map?.run(script: "map.Route.clearDestination()");
              map?.run(script: "map.Route.clear()");
              map?.run(
                  script:
                      "map.Route.placeholder(document.getElementById('result'))");
              map?.run(
                  script:
                      "map.Route.add({ lon: ${_location!.longitude}, lat: ${_location!.latitude} })");
              map?.run(
                  script:
                      "map.Route.add({ lon: 102.83007640247307, lat: 16.46690294417783 })");

              map?.run(script: "map.Route.search()");
            }
            print(
                '---------------------------------------------------------------------------');
          }
          checklatlonfromlongdo();
          setState(() {});
        }
      });
    }
  }

  showdata() async {
    print('showdata !!!!!!!!!!!!!!!!!!!');
    dataforshow = [];
    var params;
    await get(context, 'api/location', params).then((value) {
      dataAllLocation = value;
      if (dataAllLocation!.length != 0) {
        for (var i = 0; i < dataAllLocation!.length; i++) {
          dataforshow?.add(LocationDataModel.fromJson(dataAllLocation?[i]));
        }
      }
      setState(() {});
      // if (dataforshow != null) {
      //   for (var item in dataforshow!) {
      //     print(
      //         '-------------------------------------------------------------');
      //     print(item.latitude);
      //     print(item.longitude);
      //     print(item.createdAt);
      //     print(
      //         '-------------------------------------------------------------');
      //   }
      // }

      //  for (var item in value) {

      //  }
    });
    setState(() {});
  }

  checklatlonfromlongdo() async {
    var testmap = await map?.currentLocation();
    print("lat from longdo : ${testmap?.lat}");
    print("lon from longdo : ${testmap?.lon}");
  }

  gotolocation() async {
    _location = await location.getLocation();
    if (_location != null) {
      await map?.go(lon: _location?.longitude, lat: _location?.latitude);
      print('---------------------------------------------');
      final markerdetail = '''
      var yourlocation = new longdo.Marker({ lon: ${_location?.longitude}, lat: ${_location?.latitude} },
        {
          title: 'Marker',
          icon: {
          url: "https://cdn-icons-png.flaticon.com/512/1249/1249927.png",
          offset: { x: 15, y:15  },
          size: { width: 30, height: 30 }
                },
          detail: 'Drag me',
          draggable: true,
          weight: longdo.OverlayWeight.Top,
      })''';
      map?.run(script: markerdetail);
      map?.run(script: 'map.Overlays.add(yourlocation)');
      print('---------------------------------------------');
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.DATA,
        home: Scaffold(
            appBar: AppBar(
              actions: [
                Text('จำนวนการส่ง : ${i.toString()}'),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (_location != null) {
                      routing = true;
                      setState(() {});
                      map?.run(
                          script:
                              "map.Route.placeholder(document.getElementById('result'))");
                      map?.run(
                          script:
                              "map.Route.add({ lon: ${_location!.longitude}, lat: ${_location!.latitude} })");
                      map?.run(
                          script:
                              "map.Route.add({ lon: 102.83007640247307, lat: 16.46690294417783 })");
                      map?.run(script: "map.RouteType.AllDrive()");
                      // map?.run(script: "map.Route.search()");
                    }
                  },
                  child: Text('ทดสอบหาเส้นทาง'),
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    routing = false;
                    i = 0;
                    setState(() {});
                    map?.run(script: "map.Route.clearDestination()");
                    map?.run(script: "map.Route.clear()");
                  },
                  child: Text('ลบเส้นทาง'),
                )
              ],
            ),
            key: global,
            body: Builder(builder: (context) {
              return Column(children: <Widget>[
                _location?.longitude == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        // width: 500,
                        // height: 1000,
                        child: Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: LongdoMapView(
                                      apiKey: API_KEY,
                                      listener: this,
                                      markers: markers),
                                ),
                                // Positioned(
                                //     width: 100,
                                //     height: 30,
                                //     bottom: 20,
                                //     right: 10,
                                //     child: ElevatedButton(
                                //         onPressed: () {
                                //           showsheet(context);
                                //         },
                                //         child: Text('เปิดข้อมูล'))),
                              ],
                            ),
                            flex: 1),
                      ),
                Row(children: <Widget>[
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          map?.zoom(zoom: Zooms.IN, anim: true);
                        },
                      ),
                      flex: 1),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          map?.zoom(zoom: Zooms.OUT, anim: true);
                        },
                      ),
                      flex: 1),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: () async {
                          var location = await map?.currentLocation();
                          if (location != null) {
                            print(location.lat);
                            print(location.lon);
                            map?.go(lon: location.lon, lat: location.lat);
                          }
                        },
                      ),
                      flex: 1),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.pin_drop),
                        onPressed: () async {
                          final mapLocation = await map?.crosshairLocation();
                          map?.run(
                              script:
                                  'var markerOnmap = new longdo.Marker({ lon: ${mapLocation?.lon}, lat: ${mapLocation?.lat} })');
                          map?.run(script: 'map.Overlays.add(markerOnmap)');
                        },
                      ),
                      flex: 1),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          map?.run(script: 'map.Overlays.bounce(null)');
                          map?.run(script: 'map.Overlays.clear()');
                          final markerdetail = '''
                            var yourlocation = 
                            new longdo.Marker({ lon: ${_location?.longitude}, lat: ${_location?.latitude} },
                            {
                              icon: {url: "https://cdn-icons-png.flaticon.com/512/1249/1249927.png",
                              offset: { x: 15, y:15  },
                              size: { width: 30, height: 30 }
                            }
                            }) 
                        ''';
                          map?.run(script: markerdetail);
                          map?.run(script: 'map.Overlays.add(yourlocation)');
                        },
                      ),
                      flex: 1)
                ])
              ]);
            }),
            floatingActionButton: Builder(
              builder: (context) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Container(
                      width: 100,
                      height: 40,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          showsheet(context);
                        },
                        label: Text('ดูข้อมูล'),
                        icon: Icon(Icons.add),
                        backgroundColor: Colors.pink,
                      ),
                    ));
              },
            )));
  }

  void manageLayer(String layer) {
    switch (layer) {
      case Layers.LAYER_THAICHOTE:
        thaiChote = !thaiChote;
        map?.layer(layer: Layers.LAYER_THAICHOTE, add: thaiChote);
        break;
      case Layers.LAYER_TRAFFIC:
        traffic = !traffic;
        map?.layer(layer: Layers.LAYER_TRAFFIC, add: traffic);
        break;
    }
  }

  Future showsheet(BuildContext context) {
    return showSlidingBottomSheet(context,
        builder: (context) => SlidingSheetDialog(
            cornerRadius: 20,
            avoidStatusBar: true,
            snapSpec: SnapSpec(snappings: [0.3, 0.7, 1]),
            headerBuilder: (context, state) {
              return Material(
                child: Container(
                    height: 30,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(IconData(0xf71f, fontFamily: 'MaterialIcons')),
                      ],
                    )),
              );
            },
            builder: (context, state) => Material(
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ข้อมูลที่ถูกบันทึก',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     // ElevatedButton(
                      //     //     onPressed: () {
                      //     //       Navigator.pop(context);
                      //     //     },
                      //     //     child: Text('ปิด')),
                      //   ],
                      // ),
                      dataforshow == null
                          ? Text('data')
                          : Container(
                              width: 300,
                              // height: 1000,
                              child: ListView.builder(
                                  // reverse: true,
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dataforshow!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Text(
                                          '# ${index + 1}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                'lat : ${dataforshow![index].latitude}'),
                                            Text(
                                                'lon : ${dataforshow![index].longitude}'),
                                            Text(
                                                'Time : ${dataforshow![index].createdAt}'),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                            ),
                    ],
                  ),
                )));
  }
  // void showsheet(BuildContext context) {
  //   showSlidingBottomSheet(context,
  //       builder: (context) => SlidingSheetDialog(
  //           cornerRadius: 20,
  //           avoidStatusBar: true,
  //           snapSpec: SnapSpec(snappings: [0.4, 7, 1]),
  //           builder: (context, state) => Material(
  //                 child: ListView(
  //                   shrinkWrap: true,
  //                   primary: false,
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               ElevatedButton(
  //                                   onPressed: () {
  //                                     Navigator.pop(context);
  //                                   },
  //                                   child: Text('ปิด')),
  //                             ],
  //                           ),
  //                           dataforshow == null
  //                               ? Text('data')
  //                               : Container(
  //                                   width: 300,
  //                                   // height: 1000,
  //                                   child: ListView.builder(
  //                                       itemCount: dataforshow!.length,
  //                                       itemBuilder: (context, index) {
  //                                         return Column(
  //                                           children: [
  //                                             Text('ข้อมูลที่ถูกบันทึก'),
  //                                             Column(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.start,
  //                                               children: [
  //                                                 Text(
  //                                                     'lat : ${dataforshow![index].latitude}'),
  //                                                 Text(
  //                                                     'lon : ${dataforshow![index].longitude}'),
  //                                                 Text(
  //                                                     'Time : ${dataforshow![index].createdAt}'),
  //                                               ],
  //                                             )
  //                                           ],
  //                                         );
  //                                       }),
  //                                 )
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )));
  // }

  @override
  void onInit(MapController map) {
    gotolocation();
    this.map = map;
    map.run(script: "map.Ui.Crosshair.visible(false)");
    map.run(script: "map.zoom(20, true)");
    // Future.delayed(Duration.zero, () => showsheet(context));
    // await showsheet(context);
  }

  @override
  void onOverlayClicked(BaseOverlay overlay) {
    if (overlay is Marker) {
      var location = overlay.mapLocation;
      map?.go(lon: location.lon, lat: location.lat);
    }
  }
}
