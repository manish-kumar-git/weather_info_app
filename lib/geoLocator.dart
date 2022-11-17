import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:locateweather/apiCall.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController addCtr = TextEditingController();
TextEditingController latCtr = TextEditingController();
TextEditingController logCtr = TextEditingController();
var lat;
var log;
var width;
var heigth;
var _formKey = GlobalKey<FormState>();

void locate() async {

  await ApiCall().fetchWeather(latCtr.text,logCtr.text);
  List<Placemark> locations = await placemarkFromCoordinates(
      double.parse(latCtr.text), double.parse(logCtr.text));
  print('Address  ${locations.toString()}');
}

void locateAdd() async {
  List<Location> coordinates = await locationFromAddress(addCtr.text);
  Location place = coordinates[0];
  lat = place.latitude;
  log = place.longitude;
  print('${coordinates.toString()}');
  await ApiCall().fetchWeather(lat,log);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 10;
    heigth = MediaQuery.of(context).size.height / 10;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(
              tabs: [
                new Tab(
                  text: "Address",
                  icon: new Icon(Icons.search),
                ),
                new Tab(
                  text: "Coordinates",
                  icon: new Icon(Icons.pin_drop),
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: TabBarView(
              children: [byAddress(), byCoordinate()],
            ),
          ),
        ),
      ),
    );
  }

  Widget byAddress() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 8,
          ),
          child: Text(
            'Weather from Location',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: width * 6,
                child: TextFormField(
                  cursorColor: Colors.blueGrey,
                  validator: (val) => val!.isEmpty ? 'Cannot be empty' : null,
                  textAlign: TextAlign.start,
                  controller: addCtr,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Address',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.25),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      counter: const SizedBox()),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    locate();
                    print('Clicked');
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: const Text(
                  "Locate",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget byCoordinate() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 8,
            ),
            child: Text(
              'Weather from Co-ordinates',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: width * 3,
                  child: TextFormField(
                    cursorColor: Colors.blueGrey,
                    validator: (val) => val!.isEmpty ? 'Cannot be empty' : null,
                    textAlign: TextAlign.start,
                    controller: latCtr,
                    autofocus: false,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: InputDecoration(
                        hintText: 'Latitude',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.25),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        counter: const SizedBox()),
                  ),
                ),
                SizedBox(
                  width: width * 3,
                  child: TextFormField(
                    cursorColor: Colors.blueGrey,
                    validator: (val) => val!.isEmpty ? 'Cannot be empty' : null,
                    textAlign: TextAlign.start,
                    controller: logCtr,
                    autofocus: false,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: InputDecoration(
                        hintText: 'Longitude',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.25),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        counter: const SizedBox()),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      locate();
                      print('Clicked');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  child: Text(
                    "Locate",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
