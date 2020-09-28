import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:kochava_studio/studio_extensions.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:kochava_tracker/kochava_tracker.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class InfoDisplayCard extends StatefulWidget {
  InfoDisplayCard() : super();

  _InfoDisplayCardState createState() => _InfoDisplayCardState();
}

class _InfoDisplayCardState extends State<InfoDisplayCard> {
  String _advertisingIdType = 'ADID';
  String _platformIdType = 'Android ID';
  GlobalKey key = new GlobalKey();
  String _adid, _platformId, _kvid;
  bool _lat;

  @override
  void initState() {
    super.initState();
    initialState();
  }

  showPopup() {
    String popupText = '';

    if (Platform.isAndroid) {
      popupText =
          'The ADID (also called GAID) is an advertising ID provisioned by Google. This will be the primary identifier to measure and test.\n\n The Android ID and Kochava Device ID are both unique to this app and are not useful for troubleshooting, but good to have anyways.';
    } else if (Platform.isIOS) {
      popupText =
          'The IDFA is provisioned by Apple for measuring advertisement conversions. Please be aware, if it is blank or NULL, it is likely that you have Limit Ad Tracking implemented.';
    } else {
      popupText =
          'No idea what platform this is, so not sure what these IDs are.';
    }

    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        text: popupText,
        textStyle: TextStyle(color: Colors.white),
        height: 200,
        width: 200,
        backgroundColor: kochavaWhite,
        padding: EdgeInsets.all(4.0),
        borderRadius: BorderRadius.circular(10.0));

    popup.show(
      widgetKey: key,
    );
  }

  copyInfo() {
    String output = '';

    if (Platform.isAndroid) {
      output =
          'ADID:\n$_adid\n\nAndroid ID:\n$_platformId\n\nKochava ID:\n$_kvid';
    } else if (Platform.isIOS) {
      output = 'IDFA:\n$_adid\n\nIDFV:\n$_platformId\n\nKochava ID:\n$_kvid';
    } else {
      output =
          'Unknown:\n$_adid\n\nUnknown:\n$_platformId\n\nKochava ID:\n$_kvid';
    }

    FlutterClipboard.copy(output).then((value) => print('copied'));
  }

  shareInfo() {
    String output = '';

    if (Platform.isAndroid) {
      output =
          'ADID:\n$_adid\n\nAndroid ID:\n$_platformId\n\nKochava ID:\n$_kvid';
    } else if (Platform.isIOS) {
      output = 'IDFA:\n$_adid\n\nIDFV:\n$_platformId\n\nKochava ID:\n$_kvid';
    } else {
      output =
          'Unknown:\n$_adid\n\nUnknown:\n$_platformId\n\nKochava ID:\n$_kvid';
    }

    Share.share(output, subject: 'Kochava Debug Data');
  }

  initialState() async {
    String tempAdid, tempPlatformId, tempKvid;
    bool tempLat;
    var config = {
      KochavaTracker.PARAM_ANDROID_APP_GUID_STRING_KEY:
          'kokochava-studio-dev-mjmmwqjaw',
      KochavaTracker.PARAM_IOS_APP_GUID_STRING_KEY: 'kokochava-studio-7lbfbpr3',
    };
    KochavaTracker.instance.configure(config);

    try {
      tempAdid = await AdvertisingId.id;
    } on PlatformException {
      tempAdid = 'Waiting...';
    }

    try {
      tempLat = await AdvertisingId.isLimitAdTrackingEnabled;
    } on PlatformException {
      tempLat = true;
    }

    try {
      tempPlatformId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      tempPlatformId = 'Waiting...';
    }

    try {
      tempKvid = await KochavaTracker.instance.getDeviceId;
    } on PlatformException {
      tempKvid = 'Waiting...';
    }

    if (!mounted) return;

    setState(() {
      _adid = tempAdid;
      _platformId = tempPlatformId;
      _kvid = tempKvid;
      _lat = tempLat;
    });
  }

  refreshIds() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      _advertisingIdType = 'ADID: ';
      _platformIdType = 'Android ID: ';
    } else if (Platform.isIOS) {
      _advertisingIdType = 'IDFA: ';
      _platformIdType = 'IDFV: ';
    } else {
      _advertisingIdType = 'Unknown Platform Ad ID: ';
      _platformIdType = 'Unknown Platform ID: ';
    }

    return Container(
        child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Device Information\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        _advertisingIdType,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '$_adid\n',
                      )),
                  Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        _platformIdType,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '$_platformId\n',
                      )),
                  Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'Kochava kvId:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '$_kvid\n',
                      )),
                  Align(
                    alignment: Alignment(0.8, -1.0),
                    heightFactor: 0.5,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Ink(
                            decoration: ShapeDecoration(shape: CircleBorder()),
                            child: FloatingActionButton(
                                onPressed: () => shareInfo(),
                                tooltip: 'Share',
                                child: Icon(Icons.share)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Ink(
                            decoration: ShapeDecoration(shape: CircleBorder()),
                            child: FloatingActionButton(
                                onPressed: () => copyInfo(),
                                tooltip: 'Copy to clipboard',
                                child: Icon(Icons.content_copy)),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Ink(
                              decoration:
                                  ShapeDecoration(shape: CircleBorder()),
                              child: FloatingActionButton(
                                  onPressed: () => showPopup(),
                                  tooltip: 'Refresh device data',
                                  key: key,
                                  child: Icon(Icons.info_outline)),
                            ))
                      ],
                    ),
                  )
                ])),
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: kochavaGrey,
            blurRadius: 10.0,
          )
        ]));
  }
}
