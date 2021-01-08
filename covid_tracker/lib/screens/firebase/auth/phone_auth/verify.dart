import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_tracker/screens/home.dart';
import 'package:covid_tracker/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_tracker/providers/phone_auth.dart';
import 'package:covid_tracker/utils/constants.dart';
import 'package:covid_tracker/widgets/auth_widgets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {
  static const routeName = 'verify';
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  final Color cardBackgroundColor = DarkTheme.background;
  final String logo = Assets.doctor;
  final String appName = "COVID TRACKER";

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double _height, _width, _fixedPadding, _trimHeight;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _trimHeight = _height - MediaQuery.of(context).padding.top;
    _fixedPadding = _height * 0.030;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    /*
     *  Scaffold: Using a Scaffold widget as parent
     *  SafeArea: As a precaution - wrapping all child descendants in SafeArea, so that even notched phones won't loose data
     *  Center: As we are just having Card widget - making it to stay in Center would really look good
     *  SingleChildScrollView: There can be chances arising where
     */
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: DarkTheme.appBar,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  /*
   *  Widget hierarchy ->
   *    Scaffold -> SafeArea -> Center -> SingleChildScrollView -> Card()
   *    Card -> FutureBuilder -> Column()
   */
  Widget _getBody() => Container(
        color: widget.cardBackgroundColor,
        child: SizedBox(
          height: _trimHeight,
          width: _width,
          child: _getColumnBody(),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child:
                PhoneAuthWidgets.getLogo(logoPath: widget.logo, width: _width),
          ),

          // AppName:
          Text(widget.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: DarkTheme.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),

          SizedBox(height: 50.0),
          Text('OTP Verification',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: DarkTheme.secondary,
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal)),

          SizedBox(height: 20.0),
          //  Info text
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'We will send ',
                        style: TextStyle(
                            color: DarkTheme.secondaryText,
                            fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: 'One Time Password',
                        style: TextStyle(
                            color: DarkTheme.primaryText,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: ' to this mobile number',
                        style: TextStyle(
                            color: DarkTheme.secondaryText,
                            fontWeight: FontWeight.w400)),
                  ])),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),

          SizedBox(height: 32.0),
          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'VERIFY',
                style: TextStyle(color: DarkTheme.primary, fontSize: 18.0),
              ),
            ),
            color: DarkTheme.button,
          )
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  signIn() {
    if (code.length != 6) {
      _showSnackBar("Invalid OTP");
    } else {
      Provider.of<PhoneAuthDataProvider>(context, listen: false)
          .verifyOTPAndLogin(smsCode: code);
    }
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
//          autofocus: key.contains("1") ? true : false,
          autofocus: false,
          focusNode: focusNode,

          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: DarkTheme.primary,
                width: 0.0,
              ),
            ),
          ),
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: DarkTheme.primary,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 28.0,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: Colors.white),
//          decoration: InputDecoration(
//              contentPadding: const EdgeInsets.only(
//                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
//              focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide:
//                      BorderSide(color: Colors.blueAccent, width: 2.25)),
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  onStarted() {
    _showSnackBar("PhoneAuth started");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    _showSnackBar("OPT sent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    _showSnackBar("OPT resent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    _showSnackBar(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => Home()));
  }

  onFailed() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar("PhoneAuth failed");
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    _showSnackBar("PhoneAuth autoretrieval timeout");
//    _showSnackBar(phoneAuthDataProvider.message);
  }
}
