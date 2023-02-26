
import 'package:courierx/services/pickup/requestpickup.dart';
import 'package:courierx/ui/main/meansmenutransport.dart';
import 'package:courierx/ui/widgets/easyDialog2.dart';
import 'package:courierx/ui/widgets/ibackbutton.dart';
import 'package:courierx/ui/widgets/ibutton2.dart';
import 'package:courierx/ui/widgets/iinputField2.dart';
import 'package:courierx/ui/widgets/iinputField3.dart';
import 'package:courierx/ui/main/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:provider/provider.dart';
import 'package:courierx/model/pickorders.dart';
import 'package:toast/toast.dart';
import 'package:place_picker/place_picker.dart';

import '../../servicelocator.dart';

class MakeADeliveryScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>)? callback;
  final Map<String, dynamic>? params;
  MakeADeliveryScreen({Key? key, this.callback, this.params}) : super(key: key);

  @override
  _MakeADeliveryScreenState createState() => _MakeADeliveryScreenState();
}

class _MakeADeliveryScreenState extends State<MakeADeliveryScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  RequestPickup requestPickup = serviceLocator<RequestPickup>();
  late Position _currentPosition;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String locationvalue = "";
  String locationvalue2 = "";
  late double slat;
  late double slng;

  late double rlat;
  late double rlng;
  double earthRadius = 6371000;
  late double distanceInMeters;
  int itemcount = 0;
  List<Itemsadd> itemsadd = [];
  String description = "";


// For storing the current position

  bool _serviceEnabled = false;
  late Pickorders pickuporder;

  _getCurrentLocation() async {
    // final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    // final status = await Permission.locationWhenInUse.request();
    // if (status == PermissionStatus.granted) {
    //   isGpsOn = serviceStatus == ServiceStatus.enabled;
    //   print('Permission granted');
    // } else if (status == PermissionStatus.denied) {
    //   print('Denied. Show a dialog with a reason and again ask for the permission.');
    // } else if (status == PermissionStatus.permanentlyDenied) {
    //   print('Take the user to the settings page.');
    // }
    Location location = new Location();

    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await GeolocatorPlatform.instance
        .getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best))
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');
      });
    }).catchError((e) {
      print(e);
    });
  }

  _onpickup() async {
    _onDistance();
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    editControllerPCategory =
        Provider.of<AccountViewModel>(context, listen: false).option;
    for (int i = 0; i < itemsadd.length; i++) {
      description = description +
          "(" +
          itemsadd[i].count.toString() +
          ") " +
          itemsadd[i].name.text +
          ", ";
    }

    pickuporder = await requestPickup.addNewPickup(
        editControllerName.text,
        editControllerAddress.text,
        editControllerPhone.text,
        editControllerMobilePhone.text,
        editControllerPCategory,
        editControllerPCategory,
        "${editControllerDesc.text}. A total of ${itemQuantityController.text} item(s)",
        editControllerSLocation,
        editControllerRLocation,
        token,
        distanceInMeters,
        slat.toString(),
        slng.toString(),
        rlat.toString(),
        rlng.toString(),
    );
    debugPrint('Checking Pickuporderm _onpickup pickuporders: ${pickuporder.long2}');
    pickuporder.setDriverid('testId');
    Provider.of<AccountViewModel>(context, listen: false)
        .pickupset(pickuporder);

  }


  _saveData(BuildContext context) {
    editControllerPhone = editControllerMobilePhone;
    if (editControllerName.text != "" &&
        editControllerDesc.text != "" &&
        editControllerMobilePhone.text != "" &&
        editControllerAddress.text != "" &&
        editControllerPCategory != "" &&
        editControllerPhone.text != "" &&
        editControllerRLocation != "" &&
        itemQuantityController.text != "" &&
        editControllerSLocation != "") {
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login


      debugPrint("slat : $slat");
      _onpickup();
      _onDistance();
      Provider.of<AccountViewModel>(context, listen: false).setstagep(1);
      Future.delayed(const Duration(seconds: 6), () {
        print("_savedata in pickupoderm : ${pickuporder.youurlocation}");
        route.push(context, "/delivery");
      });
    } else {
      ToastView.createView('One or More Fields are missing', context,
          Toast.lengthLong, Toast.bottom, Colors.pink,TextStyle(fontSize: 13), 20,Border.all(style: BorderStyle.none), null);
    }
  }

  _onDistance() async {
    distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
      slat,
      slng,
      rlat,
      rlng,
    );
  }

  _onSaveDetails1() async {
    final String gapikeys =
        Provider.of<AccountViewModel>(context, listen: false).gapikey;

    var location =
        new LatLng(_currentPosition.latitude, _currentPosition.longitude);

    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(gapikeys,
              displayLocation: location,
            )));

    setState(() {
      editControllerSLocation = result.formattedAddress!;
      editControllerAddress.text = editControllerSLocation;
      locationvalue = result.formattedAddress!;
      editControllerSdesc.text = result.formattedAddress!;
    });
    LatLng? rlatlng = result.latLng;
    slat = rlatlng!.latitude;
    slng = rlatlng.longitude;

  }

  _onSaveDetails2() async {
    final String gapikeys =
        Provider.of<AccountViewModel>(context, listen: false).gapikey;
    var location =
        new LatLng(_currentPosition.latitude, _currentPosition.longitude);
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(gapikeys,
              displayLocation: location,
            )));
    LatLng? rlatlng = result.latLng;
    rlat = rlatlng!.latitude;
    rlng = rlatlng.longitude;

    setState(() {
      editControllerRLocation =result.formattedAddress!;
      locationvalue2 = result.formattedAddress!;
      editControllerRdesc.text = result.formattedAddress!;
    });

  }

  _onBackPressed() {
    widget.callback!(_getStringParam("backRoute"), {});
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  var editControllerName = TextEditingController();
  var editControllerAddress = TextEditingController();
  var editControllerPhone = TextEditingController();
  var editControllerMobilePhone = TextEditingController();
  var editControllerLatitude = TextEditingController();
  var editControllerLongitude = TextEditingController();
  var editControllerDesc = TextEditingController();
  // var editControllerPackage = TextEditingController();
  var locationcontrolller = TextEditingController();
  String editControllerPCategory = "Bike";
  var editControllerSLocation = "";
  var editControllerRLocation = "";
  var editControllerSdesc = TextEditingController();
  var itemQuantityController = TextEditingController();



  var editControllerRdesc = TextEditingController();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  var itemselcted = TextEditingController();

  _initEditControllers() {
    editControllerLatitude.text =
        _getDoubleParam("latitude").toStringAsFixed(6);
    editControllerLongitude.text =
        _getDoubleParam("longitude").toStringAsFixed(6);
    editControllerName.text = _getStringParam("name");
    editControllerAddress.text = _getStringParam("Address");
    editControllerPhone.text = _getStringParam("phone");
    editControllerMobilePhone.text = _getStringParam("mobilephone");
    editControllerDesc.text = _getStringParam("desc");
    var lat = _getDoubleParam("backLatitude");
    var lng = _getDoubleParam("backLongitude");
    if (lat != 0 && lng != null) {
      editControllerLatitude.text = lat.toStringAsFixed(6);
      editControllerLongitude.text = lng.toStringAsFixed(6);
    }
  }

  @override
  void initState() {
    _initEditControllers();
    _getCurrentLocation();


    super.initState();
  }

  double _getDoubleParam(String name) {
    if (widget.params != null) {
      var _ret = widget.params![name];
      if (_ret == null) _ret = 0.0;
      return _ret;
    }
    return 0.0;
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerAddress.dispose();
    editControllerPhone.dispose();
    editControllerMobilePhone.dispose();
    editControllerLongitude.dispose();
    itemQuantityController.dispose();
    editControllerDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: theme.colorBackground,

        body: Stack(
          children: <Widget>[
            Container(
              // margin:
              //     EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
              child: _body(),
            ),
            IEasyDialog2(
              setPosition: (double value) {
                _show = value;
              },
              getPosition: () {
                return _show;
              },
              color: theme.colorGrey,
              body: _body3(),
              backgroundColor: theme.colorBackground,
            ),
            Container(
              margin: EdgeInsets.only(left: 5, top: 40),
              alignment: Alignment.topLeft,
              child: IBackButton(
                  onBackClick: () {
                    _onBackPressed();
                  },
                  color: theme.colorPrimary,
                  iconColor: Colors.white),
            ),
          ],
        ));
  }

  _body() {
    var _text = strings.get(163); // "Add new Restaurant"
    if (_getStringParam("edit") == "true")
      _text = strings.get(146); // "Request a Pickup"

    return Column(
      children: [
        SizedBox(
          height: 89,
        ),
        Container(
            alignment: Alignment.center,
            child: Text(
              _text!,
              style: theme.text18boldPrimary,
            )),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: Theme(
            data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent)),
            child: Stepper(
              type: stepperType,
              physics: ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                Step(
                  title: new Text('Personal Data'),
                  content: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15,bottom: 10),
                          child: Text(
                            strings.get(147)!,
                            style: theme.text12bold,
                          ), // Full Name
                        ),
                      ),
                      Container(
                          height: 40,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField2(
                            hint: strings.get(148)!, // Enter your name
                            type: TextInputType.text,
                            colorDefaultText: theme.colorDefaultText,
                            colorBackground: theme.colorBackground,
                            controller: editControllerName, onPressRightIcon: () {  },
                          )),

                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //     height: 40,
                      //     width: windowWidth > 800 ? 500 : windowWidth,
                      //     margin: EdgeInsets.only(left: 15, right: 15),
                      //     child: IInputField2(
                      //       hint: "Enter you address", // address
                      //       colorDefaultText: theme.colorDefaultText,
                      //       type: TextInputType.text,
                      //       colorBackground: theme.colorBackground,
                      //       controller: editControllerAddress,
                      //     )),
                      // Container(
                      //   margin: EdgeInsets.only(left: 25, right: 15, top: 4),
                      //   child: Text(
                      //     strings.get(149),
                      //     style: theme.text12bold,
                      //   ), // "Enter Your Address",
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //     height: 40,
                      //     width: windowWidth > 800 ? 500 : windowWidth,
                      //     margin: EdgeInsets.only(left: 15, right: 15),
                      //     child: IInputField2(
                      //       hint: "+234 *** *** ****", // Phone
                      //       colorDefaultText: theme.colorDefaultText,
                      //       type: TextInputType.phone,
                      //       colorBackground: theme.colorBackground,
                      //       controller: editControllerPhone,
                      //     )),
                      // Container(
                      //   margin: EdgeInsets.only(left: 25, right: 15, top: 4),
                      //   child: Text(
                      //     strings.get(151),
                      //     style: theme.text12bold,
                      //   ), // "Enter Sender Phone No",
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            strings.get(153)!,
                            style: theme.text12bold,
                          ), // "Enter Receiver Mobile Phone",
                        ),
                      ),
                      Container(
                          height: 40,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField2(
                            hint: "+234 *** *** ****", // Phone
                            colorDefaultText: theme.colorDefaultText,
                            type: TextInputType.phone,
                            colorBackground: theme.colorBackground,
                            controller: editControllerMobilePhone, onPressRightIcon: () {  },
                          )),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Package'),
                  content: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, bottom: 10, ),
                          child: Text(
                            strings.get(154)!,
                            style: theme.text12bold,
                          ), // ,
                        ),
                      ),
                      MeansTransportMenu(),
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, bottom: 10, ),
                          child: Text(
                            strings.get(160)!,
                            style: theme.text12bold,
                          ), // "Enter description",
                        ),
                      ),
                      Container(
                          height: 50,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField2(
                            hint: "Describe the contents of the package", // "Description",
                            colorDefaultText: theme.colorDefaultText,
                            type: TextInputType.text,
                            colorBackground: theme.colorBackground,
                            controller: editControllerDesc, onPressRightIcon: () {  },
                          )),

                      SizedBox(
                        height: 20,
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 15, bottom: 10, ),
                          child: Text(
                            strings.get(174)!,
                            style: theme.text12bold,
                          ), // "Enter description",
                        ),
                      ),
                      Container(
                          height: 40,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField2(
                            hint: "1,2,3,4,5,6,7,8,9......", // "Description",
                            colorDefaultText: theme.colorDefaultText,
                            type: TextInputType.text,
                            colorBackground: theme.colorBackground,
                            controller: itemQuantityController, onPressRightIcon: () {  },
                          )),
                      // Container(
                      //     height: 40,
                      //     width: windowWidth > 800 ? 500 : windowWidth,
                      //     margin: EdgeInsets.only(left: 15, right: 15),
                      //     child: IInputField3(
                      //       hint: itemdecription, // "Location pick",
                      //       colorDefaultText: theme.colorDefaultText,
                      //       type: TextInputType.text,
                      //       colorBackground: theme.colorBackground,
                      //       controller: locationcontrolller,
                      //     )),
                      // Container(
                      //   margin: EdgeInsets.only(left: 25, right: 15, top: 4),
                      //   child: IButton2(
                      //       color: theme.colorPrimary,
                      //       text: "Enter Items", // Confirm Receiver Location
                      //       textStyle: theme.text14boldWhite,
                      //       pressButton: () {
                      //         print("clicked");
                      //         _opendialogstuff(context);
                      //       }), // "Your Location",
                      // ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Addresses'),
                  content: Column(
                    children: <Widget>[
                      Container(
                          height: 40,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField3(
                            hint: locationvalue, // "Select pickup address",
                            colorDefaultText: theme.colorDefaultText,
                            type: TextInputType.text,
                            colorBackground: theme.colorBackground,
                            controller: locationcontrolller, onChangeText: (String ) {  }, onPressRightIcon: () {  },
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 15, top: 4),
                        child: IButton2(
                            color: theme.colorPrimary,
                            text: strings.get(159)!,
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              _onSaveDetails1();
                            }), // "Your Location",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: 40,
                          width: windowWidth > 800 ? 500 : windowWidth,
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: IInputField3(
                            hint: locationvalue2,
                            colorDefaultText: theme.colorDefaultText,
                            type: TextInputType.text,
                            colorBackground: theme.colorBackground,
                            controller: locationcontrolller, onChangeText: (String ) {  }, onPressRightIcon: () {  },
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 25, right: 15, top: 4),
                        child: IButton2(
                            color: theme.colorPrimary,
                            text: strings.get(161)!, // Select delivery location
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              _onSaveDetails2();
                            }), // "Your Location",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Container(
                      //   alignment: Alignment.bottomCenter,
                      //   child: IButton3(
                      //       color: Colors.blue,
                      //       text: strings.get(162), // Save
                      //       textStyle: theme.text14boldWhite,
                      //       pressButton: () {
                      //         _saveData(context);
                      //       }),
                      // ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.list),
            onPressed: switchStepsType,
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }

  _body2() {
    var list = <Widget>[];

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(148)!, // John Doe
          type: TextInputType.text,
          colorDefaultText: theme.colorDefaultText,
          colorBackground: theme.colorBackground,
          controller: editControllerName, onPressRightIcon: () {  },
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(147)!,
        style: theme.text12bold,
      ), // Full Name
    ));

    list.add(SizedBox(
      height: 20,
    ));

    // list.add(Container(
    //     height: 40,
    //     margin: EdgeInsets.only(left: 15, right: 15),
    //     child: IInputField2(
    //       hint: strings.get(150), // address
    //       colorDefaultText: theme.colorDefaultText,
    //       type: TextInputType.text,
    //       colorBackground: theme.colorBackground,
    //       controller: editControllerAddress,
    //     )));
    //
    // list.add(Container(
    //   margin: EdgeInsets.only(left: 25, right: 15, top: 4),
    //   child: Text(
    //     strings.get(149),
    //     style: theme.text12bold,
    //   ), // "Enter Your Address",
    // ));
    //
    // list.add(SizedBox(
    //   height: 20,
    // ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(152)!, // Phone
          colorDefaultText: theme.colorDefaultText,
          type: TextInputType.phone,
          colorBackground: theme.colorBackground,
          controller: editControllerPhone, onPressRightIcon: () {  },
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(151)!,
        style: theme.text12bold,
      ), // "Enter Sender Phone No",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        height: 40,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: IInputField2(
          hint: strings.get(152)!, // Phone
          colorDefaultText: theme.colorDefaultText,
          type: TextInputType.phone,
          colorBackground: theme.colorBackground,
          controller: editControllerMobilePhone, onPressRightIcon: () {  },
        )));

    list.add(Container(
      margin: EdgeInsets.only(left: 25, right: 15, top: 4),
      child: Text(
        strings.get(153)!,
        style: theme.text12bold,
      ), // "Enter Receiver Mobile Phone",
    ));

    list.add(SizedBox(
      height: 20,
    ));

    return list;
  }

  // _body22() {
  //   var list = List<Widget>();
  //   list.add(MeansTransportMenu());
  //
  //   list.add(
  //     Container(
  //       height: 40,
  //       margin: EdgeInsets.only(left: 15, right: 15),
  //       child: DropdownButton(
  //           value: editControllerPCategory,
  //           items: [
  //             DropdownMenuItem(
  //               child: Text("0 - 80kg (Bike)"),
  //               value: "0 - 80kg (Bike)",
  //             ),
  //             DropdownMenuItem(
  //               child: Text("81 - 4000kg (Small Van)"),
  //               value: "81 - 4000kg (Small Van)",
  //             ),
  //             DropdownMenuItem(
  //                 child: Text("401 - Above (Delivery Truck)"),
  //                 value: "401 - Above (Delivery Truck)"),
  //           ],
  //           onChanged: (value) {
  //             setState(() {
  //               editControllerPCategory = value;
  //             });
  //           }),
  //     ),
  //   );
  //
  //   list.add(Container(
  //     margin: EdgeInsets.only(left: 25, right: 15, top: 4),
  //     child: Text(
  //       strings.get(154),
  //       style: theme.text12bold,
  //     ), // "Enter the Package Category",
  //   ));
  //
  //   list.add(SizedBox(
  //     height: 20,
  //   ));
  //
  //   list.add(
  //     Container(
  //         height: 40,
  //         margin: EdgeInsets.only(left: 15, right: 15),
  //         child: IInputField2(
  //           hint: strings.get(156), // "Package",
  //           colorDefaultText: theme.colorDefaultText,
  //           type: TextInputType.text,
  //           colorBackground: theme.colorBackground,
  //           controller: editControllerPackage,
  //         )),
  //   );
  //
  //   list.add(Container(
  //     margin: EdgeInsets.only(left: 25, right: 15, top: 4),
  //     child: Text(
  //       strings.get(155),
  //       style: theme.text12bold,
  //     ), // "Enter Package name",
  //   ));
  //
  //   list.add(SizedBox(
  //     height: 20,
  //   ));
  //
  //   list.add(
  //     Container(
  //         height: 40,
  //         margin: EdgeInsets.only(left: 15, right: 15),
  //         child: IInputField2(
  //           hint: strings.get(157), // "Description",
  //           colorDefaultText: theme.colorDefaultText,
  //           type: TextInputType.text,
  //           colorBackground: theme.colorBackground,
  //           controller: editControllerDesc,
  //         )),
  //   );
  //
  //   list.add(Container(
  //     margin: EdgeInsets.only(left: 25, right: 15, top: 4),
  //     child: Text(
  //       strings.get(160),
  //       style: theme.text12bold,
  //     ), // "Enter description",
  //   ));
  //
  //   list.add(SizedBox(
  //     height: 20,
  //   ));
  //
  //   return list;
  // }

  // _body23() {
  //   var list = List<Widget>();
  //
  //   list.add(
  //     Container(
  //         height: 40,
  //         margin: EdgeInsets.only(left: 15, right: 15),
  //         child: IInputField3(
  //           hint: locationvalue, // "Location pick",
  //           colorDefaultText: theme.colorDefaultText,
  //           type: TextInputType.text,
  //           colorBackground: theme.colorBackground,
  //           controller: editControllerSdesc,
  //         )),
  //   );
  //
  //   list.add(Container(
  //     margin: EdgeInsets.only(left: 25, right: 15, top: 4),
  //     child: IButton2(
  //         color: theme.colorPrimary,
  //         text: strings.get(159), // Save
  //         textStyle: theme.text14boldWhite,
  //         pressButton: () {
  //           _onSaveDetails1();
  //         }), // "Your Location",
  //   ));
  //
  //   list.add(SizedBox(
  //     height: 20,
  //   ));
  //
  //   list.add(
  //     Container(
  //         height: 40,
  //         margin: EdgeInsets.only(left: 15, right: 15),
  //         child: IInputField3(
  //           hint: locationvalue2, // "Location pick",
  //           colorDefaultText: theme.colorDefaultText,
  //           type: TextInputType.text,
  //           colorBackground: theme.colorBackground,
  //           controller: editControllerRdesc,
  //         )),
  //   );
  //
  //   list.add(Container(
  //     margin: EdgeInsets.only(left: 25, right: 15, top: 4),
  //     child: IButton2(
  //         color: theme.colorPrimary,
  //         text: strings.get(161), // Confirm Receiver Location
  //         textStyle: theme.text14boldWhite,
  //         pressButton: () {
  //           _onSaveDetails2();
  //         }), // "Your Location",
  //   ));
  //
  //   // list.add(_selectImage());
  //   // list.add(SizedBox(
  //   //   height: 20,
  //   // ));
  //   // list.add(_drawImage());
  //
  //   // list.add(SizedBox(
  //   //   height: 20,
  //   // ));
  //   list.add(ILine());
  //   list.add(SizedBox(
  //     height: 20,
  //   ));
  //
  //   list.add(Container(
  //     alignment: Alignment.bottomCenter,
  //     child: IButton2(
  //         color: theme.colorPrimary,
  //         text: strings.get(162), // Save
  //         textStyle: theme.text14boldWhite,
  //         pressButton: () {
  //           _saveData(context);
  //         }),
  //   ));
  //
  //   list.add(SizedBox(
  //     height: 150,
  //   ));
  //
  //   return list;
  // }

  // Widget _drawImage() {
  //   if (_imagePath.isNotEmpty)
  //     return Container(
  //         height: windowWidth * 0.3,
  //         child: Image.file(
  //           File(_imagePath),
  //           fit: BoxFit.contain,
  //         ));
  //   else {
  //     if (_getStringParam("image").isNotEmpty)
  //       return Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: 100,
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           child: CachedNetworkImage(
  //             placeholder: (context, url) => UnconstrainedBox(
  //                 child: Container(
  //               alignment: Alignment.center,
  //               width: 40,
  //               height: 40,
  //               child: CircularProgressIndicator(
  //                 backgroundColor: theme.colorPrimary,
  //               ),
  //             )),
  //             imageUrl: _getStringParam("image"),
  //             imageBuilder: (context, imageProvider) => Container(
  //               decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                   image: imageProvider,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //             ),
  //             errorWidget: (context, url, error) => new Icon(Icons.error),
  //           ),
  //         ),
  //       );
  //   }
  //   return Container();
  // }

  Stream<List<Itemsadd>?> getNumbers(Duration refreshTime) async* {
    if (!mounted) return;

    if (this.mounted) {
      while (true) {
        await Future.delayed(refreshTime);
        yield await getChat();
      }
    }
  }

  Future<List<Itemsadd>?> getChat() async {
    if (this.mounted) {
      print(itemsadd.length);
      int count = 1;
      Itemsadd items = Itemsadd(itemselcted, count);
      //  itemsadd.add(items);
      //  List<Widget> friendsTextFieldsList = [];
      if (itemsadd.length == 0) itemsadd.add(items);
      print(itemsadd.length);
      setState(() {});
      return itemsadd;
    }
    return null;
  }

  _addProductites(List<Itemsadd> itemsget) {
    var list = <Widget>[];
    int count = 1;
    Itemsadd items = Itemsadd(itemselcted, count);
    //  itemsadd.add(items);
    List<Widget> friendsTextFieldsList = [];
    if (itemsget.length == 0) itemsget.add(items);
    print("shit ${itemsget.length}");
    // for (int i = 0; i < itemsadd.length; i++) {

    friendsTextFieldsList.add(
        //Expanded(
        //  child:
        ListView.builder(
      shrinkWrap: true,
      itemCount: itemsget.length,
      itemBuilder: (context, index) {
        return Container(
          //    child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 30,
                  width: 100,
                  child: IInputField2(
                    hint: "Items", // "Location pick",
                    colorDefaultText: theme.colorDefaultText,
                    type: TextInputType.text,
                    colorBackground: theme.colorBackground,
                    controller: itemsget[index].name, onPressRightIcon: () {  },
                  )),
              RoundedIconButton(
                icon: Icons.remove,
                iconSize: 15,
                onPress: () {
                  setState(() {
                    itemsget[index].count = itemsget[index].count - 1;
                  });
                },
              ),
              Container(
                width: 15,
                child: Text(
                  '${itemsget[index].count}',
                  style: TextStyle(
                    fontSize: 15 * 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              RoundedIconButton(
                icon: Icons.add,
                iconSize: 15,
                onPress: () {
                  setState(() {
                    itemsget[index].count = itemsget[index].count + 1;
                  });
                },
              ),
              SizedBox(
                width: 2,
              ),
              _addRemoveButton(index == itemsget.length - 1, index),
            ],
          ),
          //   ),
        );
      },
    )
        // )
        );
    //  }
    //     return friendsTextFieldsList;

    return friendsTextFieldsList;
  }

  String itemdecription = "Items : ";
  _doneClose(context) {
    itemdecription = "Items : ";
    for (int i = 0; i < itemsadd.length; i++) {
      itemdecription = itemdecription +
          "(" +
          itemsadd[i].count.toString() +
          ") " +
          itemsadd[i].name.text +
          ", ";
    }
    Navigator.of(context).pop();
  }


  Widget _addRemoveButton(bool add, int index) {
    int count = 1;
    // var index${word};
    var itemselcted = TextEditingController();
    Itemsadd items = Itemsadd(itemselcted, count);
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          itemsadd.insert(0, items);
        } else
          itemsadd.removeAt(index);
        setState(() {
          itemsadd = itemsadd;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  // _selectImage() {
  //   return Stack(
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(left: 15, right: 15),
  //         height: 100,
  //         width: windowWidth,
  //         decoration: BoxDecoration(
  //           color: theme.colorGrey,
  //           borderRadius: new BorderRadius.circular(10),
  //         ),
  //         child: Container(
  //           alignment: Alignment.bottomCenter,
  //           margin: EdgeInsets.only(bottom: 10),
  //           child: Opacity(
  //               opacity: 0.6,
  //               child: Text(
  //                 strings.get(125),
  //                 style: theme.text12bold,
  //               ) // Click here for select Image
  //               ),
  //         ), // "Enter description",
  //       ),
  //       Container(
  //         alignment: Alignment.center,
  //         margin: EdgeInsets.only(top: 10),
  //         child: UnconstrainedBox(
  //             child: Container(
  //                 height: 60,
  //                 width: 40,
  //                 child: Image.asset("assets/selectimage.png",
  //                     fit: BoxFit.contain))),
  //       ),
  //       Positioned.fill(
  //         child: Container(
  //           margin: EdgeInsets.only(left: 20, right: 20),
  //           child: Material(
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 splashColor: Colors.grey[400],
  //                 onTap: () {
  //                   _showMessage("");
  //                 }, // needed
  //               )),
  //         ),
  //       )
  //     ],
  //   );
  // }

  String _getStringParam(String name) {
    if (widget.params != null) {
      var _ret = widget.params![name];
      if (_ret == null) _ret = "";
      return _ret;
    }
    return "";
  }

  double _show = 0;

  // _showMessage(String id) {
  //   if (mounted)
  //     setState(() {
  //       _show = 1;
  //     });
  // }

  _body3() {
    return Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(
              strings.get(126)!,
              textAlign: TextAlign.center,
              style: theme.text18boldPrimary,
            ), // "Select image from",
            SizedBox(
              height: 50,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(127)!, // "Camera",
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                      getImage2(ImageSource.camera);
                    }),
                SizedBox(
                  width: 10,
                ),
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(128)!, // Gallery
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                      getImage2(ImageSource.gallery);
                    }),
              ],
            )),
          ],
        ));
  }

  final picker = ImagePicker();
  String _imagePath = "";

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {});
    }
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : _saveData(context);
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton(
      {required this.icon, required this.onPress, required this.iconSize});

  final IconData icon;
  final Function() onPress;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      elevation: 6.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(iconSize * 0.2)),
      fillColor: Color(0xFF65A34A),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize * 0.8,
      ),
    );
  }
}

dprint(String str) {
  //
  // comment this line for release app
  //
  print(str);
}

class Itemsadd {
  TextEditingController name;
  int count;

  Itemsadd(this.name, this.count);
}
