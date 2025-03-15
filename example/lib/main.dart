import 'package:dio/dio.dart';
import 'package:example/custom_router_pluggable.dart';
import 'package:example/detail_page.dart';
import 'package:example/home_page.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizeble_devices/flutter_resizeble_devices.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_channel_monitor/flutter_ume_kit_channel_monitor.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

final Dio dio = Dio()
  ..options = BaseOptions(connectTimeout: Duration(milliseconds: 1000));

void main() async {
  await GetStorage.init();

  runApp(const UMEApp());
}

class UMEApp extends StatefulWidget {
  const UMEApp({Key? key}) : super(key: key);

  @override
  State<UMEApp> createState() => _UMEAppState();
}

class _UMEAppState extends State<UMEApp> {
  late NavigatorObserverService navigatorObserverService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomRouterPluggable().navKey = navigatorKey;
    });
    navigatorObserverService = NavigatorObserverService();
    if (!kReleaseMode) {
      PluginManager.instance
        ..register(WidgetInfoInspector())
        ..register(WidgetDetailInspector())
        ..register(AlignRuler())
        ..register(ColorPicker())
        ..register(TouchIndicator())
        ..register(Performance())
        ..register(MemoryInfoPage())
        ..register(CpuInfoPage())
        ..register(DeviceInfoPanel(accessToken: 'Some token'))
        ..register(DevicePreviewPlugin())
        ..register(Console())
        ..register(DioInspector(dio: dio))
        ..register(StorageManagement(
          getStorage: GetStorage(),
        ))
        ..register(NavigatorStack(
          navigatorObserverService: navigatorObserverService,
        ))
        ..register(ChannelPlugin());
    }
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      useInheritedMediaQuery: true,
      title: 'UME Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(title: 'UME Demo Home Page'),
      navigatorObservers: [
        navigatorObserverService,
      ],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'detail':
            return MaterialPageRoute(builder: (_) => const DetailPage());
          default:
            return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildApp(context);
    if (!kReleaseMode) {
      return ChangeNotifierProvider(
        create: (_) => UMESwitch(),
        builder: (context, _) => UMEWidget(
          enable: context.watch<UMESwitch>().enable,
          child: body,
        ),
      );
    }
    return body;
  }
}
