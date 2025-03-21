import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_console/console/console_print.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
            onPressed: () {
              context.read<UMESwitch>().trigger();
            },
            icon: Icon(context.watch<UMESwitch>().enable
                ? Icons.light
                : Icons.light_sharp),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => UMEWidget.closeActivatedPlugin(),
              child: const Text('Close activated plugin'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('statement');
              },
              child: const Text('debugPrint'),
            ),
            TextButton(
              onPressed: () {
                print('print');
              },
              child: const Text('Print'),
            ),
            TextButton(
              onPressed: () {
                log('bbbbb');
              },
              child: const Text('log'),
            ),
            TextButton(
              onPressed: () {
                consolePrint('consolePrint');
              },
              child: const Text('loger'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('detail');
              },
              child: const Text('Push Detail Page'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Dialog'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
            TextButton(
              onPressed: () {
                Future.wait<void>(
                  List<Future<void>>.generate(
                    10,
                    (int i) => Future<void>.delayed(
                      Duration(seconds: i),
                      () => dio.get(
                        'https://api.github.com'
                        '/?_t=${DateTime.now().millisecondsSinceEpoch}&$i',
                        options: Options(
                          headers: {'UME-Test': 'This is UME Dio kit.'},
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Make multiple network requests'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          label: '111',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_alarm),
          label: 'www',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '222',
        ),
      ]),
    );
  }
}
