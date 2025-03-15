import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_resizeble_devices/src/ui/channel_pages.dart';
import 'package:flutter_ume/flutter_ume.dart';

import 'icon.dart' as icon;

class DevicePreviewPlugin extends PluggableWithNestedWidget {
  DevicePreviewPlugin();

  @override
  String get displayName => 'DevicePreview';

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'DevicePreview';

  @override
  Widget buildNestedWidget(Widget child) {
    return ChannelPages(
      switched: true,
      child: child,
    );
  }

  @override
  Widget? buildWidget(BuildContext? context) {
    return Container();
  }

  @override
  void onTrigger() {}
}
