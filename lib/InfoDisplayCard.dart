import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:kochava_studio/studio_extensions.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:platform_device_id/platform_device_id.dart';

class InfoDisplayCard extends StatefulWidget {
  InfoDisplayCard() : super();

  _InfoDisplayCardState createState() => _InfoDisplayCardState();
}

class _InfoDisplayCardState extends State<InfoDisplayCard> {
  String _advertisingIdType = 'ADID';
  String _platformIdType = 'Android ID';

  String _adid, _platformId, _kvid;
  bool _lat;

  @override
  void initState() {
    super.initState();
    initialState();
  }

  initialState() async {
    String tempAdid, tempPlatformId;
    bool tempLat;

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

    if (!mounted) return;

    setState(() {
      _adid = tempAdid;
      _platformId = tempPlatformId;
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
                        '$_adid',
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
                        '$_platformId',
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
                        'kv_id\n',
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
                                onPressed: () => {},
                                tooltip: 'Share',
                                child: Icon(Icons.share)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Ink(
                            decoration: ShapeDecoration(shape: CircleBorder()),
                            child: FloatingActionButton(
                                onPressed: () => {},
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
                                  onPressed: () => refreshIds(),
                                  tooltip: 'Refresh device data',
                                  child: Icon(Icons.refresh)),
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
