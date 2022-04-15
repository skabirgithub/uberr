import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uberr/widgets/app_drawer.dart';
import 'package:latlong2/latlong.dart' as ll;
// import 'package:latlng/latlng.dart' as ll;
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late ll.LatLng myLocation = ll.LatLng(23.779935, 90.426224);

  static ll.LatLng car1 = ll.LatLng(23.779925, 90.425114);
  static ll.LatLng car2 = ll.LatLng(23.778945, 90.426234);
  static ll.LatLng car3 = ll.LatLng(23.777930, 90.427320);

  late MapController mapController;

  List<Marker> _markers = [
    Marker(
      width: 60.0,
      height: 60.0,
      point: car1,
      builder: (ctx) => Container(
        child: Image.asset(
          "assets/images/car2.png",
          width: 60.0,
          height: 60.0,
        ),
      ),
    ),
    Marker(
      width: 60.0,
      height: 60.0,
      point: car2,
      builder: (ctx) => Container(
        child: Image.asset(
          "assets/images/car2.png",
          width: 60.0,
          height: 60.0,
        ),
      ),
    ),
    Marker(
      width: 60.0,
      height: 60.0,
      point: car3,
      builder: (ctx) => Container(
        child: Image.asset(
          "assets/images/car2.png",
          width: 60.0,
          height: 60.0,
        ),
      ),
    )
  ];
  @override
  void initState() {
    super.initState();
    mapController = MapController();

    getMyLocation().whenComplete(() {
      setState(() {

      });
    });
  }

  Future<void> getMyLocation() async {
    Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      myLocation = ll.LatLng(position.latitude, position.longitude);
    });
    this.setState(() {
      _markers.add(
        Marker(
          width: 120.0,
          height: 120.0,
          point: myLocation,
          builder: (ctx) => Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 30.0,
                  child: Icon(Icons.person_pin_circle),
                ),
                Container(
                  child: Text("Pick Up Here"),
                )
              ],
            ),
          ),
        ),
      );
    });
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 250.0,
                  // child: GoogleMap(
                  //   myLocationButtonEnabled: true,
                  //   myLocationEnabled: true,
                  //   markers: _markers,
                  //   onMapCreated: _onMapCreated,
                  //   initialCameraPosition: CameraPosition(
                  //     target: _center,
                  //     zoom: 11.0,
                  //   ),
                  // ),
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: myLocation,
                      zoom: 18.0,
                      onMapCreated: (omc){
                        // _animatedMapMove(car1, 18.0);
                        getMyLocation().whenComplete(() {
                          setState(() {
                            _animatedMapMove(myLocation, 18.0);
                          });

                        });

                      }

                      // controller: mapController,

                    ),
                    layers: [
                      TileLayerOptions(
                        // zoomReverse: true,
                        urlTemplate:
                            "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],


                      ),
                      MarkerLayerOptions(markers: _markers,)
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35.0,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                        // _animatedMapMove(paris, 5.0);
                      },
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(
                        0,
                        0,
                        0,
                        0.15,
                      ),
                      blurRadius: 25.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Where are you going to?",
                      style: _theme.textTheme.subtitle1,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Book on demand or pre-scheduled rides",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Hero(
                        tag: "search",
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Enter Destination",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: _theme.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Pickup'),
                          onPressed: () {
                            _animatedMapMove(myLocation, 18.1);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Car 1'),
                          onPressed: () {
                            _animatedMapMove(car1, 18.1);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Car 2'),
                          onPressed: () {
                            _animatedMapMove(car2, 18.1);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Car 3'),
                          onPressed: () {
                            _animatedMapMove(car3, 18.1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animatedMapMove(ll.LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      mapController.move(
          ll.LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }





}
