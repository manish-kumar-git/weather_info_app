import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:locateweather/apiCall.dart';
import 'package:locateweather/model.dart';
import 'package:intl/intl.dart';

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
var data = ResponseData();
var icon;
var iconUrl;
var humidity;
var wind_speed;
num temp = 0;
String? date;
int? date2 = 0;
String? time;

String city = '';
locate() async {
  List<Placemark> locations = await placemarkFromCoordinates(
      double.parse(latCtr.text), double.parse(logCtr.text));
  await ApiCall().fetchWeather(latCtr.text, logCtr.text);
  icon = responseObject.current!.weather![0].icon ?? '';
  iconUrl = "https://openweathermap.org/img/wn/$icon@2x.png";
  icon = responseObject.current!.weather![0].icon ?? '';
  iconUrl = "https://openweathermap.org/img/wn/$icon@2x.png";
  temp = responseObject.current!.temp ?? 0;
  temp = temp - 273.15;
  wind_speed = responseObject.current!.windSpeed;
  humidity = responseObject.current!.humidity;
  date2 = responseObject.current!.dt;
  date = DateTime.fromMillisecondsSinceEpoch(date2! * 1000).toString();
  time = date.toString().split(' ').last.substring(0, 5);
  final DateFormat formatter = DateFormat('MMMMd');
  final String formatted = formatter.format(DateTime.parse(date!));
  date = formatted;
  city = locations.first.locality!;
  print('Address  ${locations.toString()}');
}

locateAdd() async {
  List<Location> coordinates = await locationFromAddress(addCtr.text);
  Location place = coordinates[0];
  lat = place.latitude;
  log = place.longitude;
  print('${coordinates.toString()}');
  await ApiCall().fetchWeather(lat, log);
  icon = responseObject.current!.weather![0].icon ?? '';
  iconUrl = "https://openweathermap.org/img/wn/$icon@2x.png";
  temp = responseObject.current!.temp ?? 0;
  temp = temp - 273.15;
  wind_speed = responseObject.current!.windSpeed;
  humidity = responseObject.current!.humidity;
  date2 = responseObject.current!.dt;
  date = DateTime.fromMillisecondsSinceEpoch(date2! * 1000).toString();
  time = date.toString().split(' ').last.substring(0, 5);
  final DateFormat formatter = DateFormat('MMMMd');
  final String formatted = formatter.format(DateTime.parse(date!));
  date = formatted;
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
          backgroundColor: Colors.blueGrey.shade50,
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Address",
                  icon: Icon(Icons.search),
                ),
                Tab(
                  text: "Coordinates",
                  icon: Icon(Icons.pin_drop),
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
    final testStyle = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await locateAdd();
                      print('Clicked');
                      setState(() {
                        city = addCtr.text;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  child: const Text(
                    "Locate",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          responseObject.current == null
              ? Container()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        'Current Weather',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Material(
                        color: Colors.green.shade100,
                        elevation: 5,
                        child: SizedBox(
                          height: heigth * 4,
                          width: width * 8,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(city, style: testStyle.headline3),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Image.network(iconUrl),
                              ),
                              Text(
                                temp.toString().split('.').first + '\u2103',
                                style: testStyle.headline2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(time!.substring(0, 5),
                                            style: testStyle.subtitle1),
                                        Text(date!, style: testStyle.subtitle2),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Wind Speed: ${wind_speed.toString()} m/s",
                                            style: testStyle.subtitle1),
                                        Text(
                                            "Humidity: ${humidity.toString()} %",
                                            style: testStyle.subtitle2),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 8,
                      ),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        'Hourly Weather Report',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: ListView.builder(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                itemCount: 24,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.pink.shade100,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      responseObject
                                                              .hourly![index]
                                                              .dt! *
                                                          1000)
                                              .toString()
                                              .split(' ')
                                              .last
                                              .substring(0, 5)),
                                          Expanded(
                                              child: SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.network(
                                                      "https://openweathermap.org/img/wn/${responseObject.hourly![index].weather![0].icon}@2x.png"))),
                                          Text(
                                            '${(responseObject.hourly![index].temp!.toDouble() - 273.15).toString().split('.').first}\u2103',
                                            style: testStyle.labelLarge,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 8,
                      ),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        'Daily Weather Report',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: ListView.builder(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                itemCount: 24,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  DateTime base =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          responseObject.daily![index].dt! *
                                              1000);
                                  final DateFormat formatter = DateFormat('E');
                                  final String formatted =
                                      formatter.format(base);
                                  var url =
                                      "https://openweathermap.org/img/wn/${responseObject.daily![index].weather![0].icon}@2x.png";
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade100,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(formatted),
                                          Expanded(
                                              child: SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.network(url))),
                                          Text(
                                            '${(responseObject.daily![index].temp!.day!.toDouble() - 273.15).toString().split('.').first}\u2103',
                                            style: testStyle.labelLarge,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
        ],
      ),
    );
  }

  Widget byCoordinate() {
    final testStyle = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Center(
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
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be empty' : null,
                      textAlign: TextAlign.start,
                      controller: latCtr,
                      autofocus: false,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                          hintText: 'Latitude',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.25),
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
                      validator: (val) =>
                          val!.isEmpty ? 'Cannot be empty' : null,
                      textAlign: TextAlign.start,
                      controller: logCtr,
                      autofocus: false,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                          hintText: 'Longitude',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.25),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await locate();
                        setState(() {});
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
            responseObject.current == null
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          'Current Weather',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Material(
                          color: Colors.indigo.shade100,
                          elevation: 5,
                          child: SizedBox(
                            height: heigth * 4,
                            width: width * 8,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(city, style: testStyle.headline3),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Image.network(iconUrl),
                                ),
                                Text(
                                  temp.toString().split('.').first + '\u2103',
                                  style: testStyle.headline2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(time!.substring(0, 5),
                                              style: testStyle.subtitle1),
                                          Text(date!,
                                              style: testStyle.subtitle2),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              "Wind Speed: ${wind_speed.toString()} m/s",
                                              style: testStyle.subtitle1),
                                          Text(
                                              "Humidity: ${humidity.toString()} %",
                                              style: testStyle.subtitle2),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 8,
                        ),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          'Hourly Weather Report',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  itemCount: responseObject.hourly!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        responseObject
                                                                .hourly![index]
                                                                .dt! *
                                                            1000)
                                                .toString()
                                                .split(' ')
                                                .last
                                                .substring(0, 5)),
                                            Expanded(
                                                child: SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: Image.network(
                                                        "https://openweathermap.org/img/wn/${responseObject.hourly![index].weather![0].icon}@2x.png"))),
                                            Text(
                                              '${(responseObject.hourly![index].temp!.toDouble() - 273.15).toString().split('.').first}\u2103',
                                              style: testStyle.labelLarge,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 8,
                        ),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          'Daily Weather Report',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: ListView.builder(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  itemCount: responseObject.daily!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    DateTime base =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            responseObject.daily![index].dt! *
                                                1000);
                                    final DateFormat formatter =
                                        DateFormat('E');
                                    final String formatted =
                                        formatter.format(base);
                                    var url =
                                        "https://openweathermap.org/img/wn/${responseObject.daily![index].weather![0].icon}@2x.png";
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade100,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(formatted),
                                            Expanded(
                                                child: SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: Image.network(url))),
                                            Text(
                                              '${(responseObject.daily![index].temp!.day!.toDouble() - 273.15).toString().split('.').first}\u2103',
                                              style: testStyle.labelLarge,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
