import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:platform/platform.dart';

import 'icon.dart' as icon;

class DeviceInfoPanel extends StatefulWidget implements Pluggable {
  final Platform platform;
  final String accessToken;

  const DeviceInfoPanel({
    this.platform = const LocalPlatform(),
    required this.accessToken,
  });

  @override
  _DeviceInfoPanelState createState() => _DeviceInfoPanelState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'DeviceInfo';

  @override
  String get displayName => 'DeviceInfo';

  @override
  void onTrigger() {}
}

class _DeviceInfoPanelState extends State<DeviceInfoPanel> {
  String _content = '';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  void _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map dataMap = Map();
    if (widget.platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      dataMap = _readAndroidBuildData(androidDeviceInfo);
    } else if (widget.platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      dataMap = _readIosDeviceInfo(iosDeviceInfo);
    }
    var token = await _addFcmToken();
    dataMap.addAll(token);
    dataMap['accessToken'] = widget.accessToken;
    StringBuffer buffer = StringBuffer();
    dataMap.forEach((k, v) {
      buffer.write('$k:  $v\n');
    });
    _content = buffer.toString();
    setState(() {});
  }

  _addFcmToken() async {
    try {
      var token = await FirebaseMessaging.instance.getToken() ?? '';
      return {'fcmToken': token};
    } catch (_) {
      return {'fcmToken': 'empty'};
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.name
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname': data.utsname.sysname,
      'utsname.nodename': data.utsname.nodename,
      'utsname.release': data.utsname.release,
      'utsname.version': data.utsname.version,
      'utsname.machine': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 32, bottom: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.black.withOpacity(0.85),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Device Info',
                  textScaleFactor: 1.15,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: _content));
                  await HapticFeedback.vibrate();
                },
                icon: Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 150),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SelectableText(_content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  strutStyle:
                      const StrutStyle(forceStrutHeight: true, height: 2)),
            ),
          ),
        ],
      ),
    );
  }
}
