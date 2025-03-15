import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';

import 'icon.dart' as icon;
import 'navigation_stack_service.dart';

class NavigatorStack extends StatefulWidget implements Pluggable {
  final NavigatorObserverService navigatorObserverService;

  const NavigatorStack({
    required this.navigatorObserverService,
  });

  @override
  _NavigatorStackState createState() => _NavigatorStackState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'Navigator';

  @override
  String get displayName => 'Navigator';

  @override
  void onTrigger() {}
}

class _NavigatorStackState extends State<NavigatorStack> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView.separated(
        itemCount: widget.navigatorObserverService.routeStack.length,
        itemBuilder: (context, index) {
          final route = widget.navigatorObserverService.routeStack[index];
          return _buildTree(route);
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.black);
        },
      ),
    );
  }

  Widget _buildTree(Route<dynamic> route) {
    return ExpansionTile(
      title: Text(route.settings.name ?? 'Route name'),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: InputBorder.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(route.settings.toString()),
              Text('route.isActive ${route.isActive}'),
              Text('route.isFirst ${route.isFirst}'),
              Text('route.isCurrent ${route.isCurrent}'),
              Text('route.currentResult ${route.currentResult}'),
              Text('route.overlayEntries ${route.overlayEntries.toString()}'),
              Text('route.popDisposition ${route.popDisposition}'),
              ExpansionTile(
                title: Text('Navigator'),
                shape: InputBorder.none,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('restorationId ${route.navigator?.restorationId}'),
                  Text('focusNode ${route.navigator?.focusNode}'),
                  Text('overlay ${route.navigator?.overlay}'),
                  Text('context ${route.navigator?.context}'),
                  Text('mounted ${route.navigator?.mounted}'),
                  Text('restorePending ${route.navigator?.restorePending}'),
                ],
              ),
              ExpansionTile(
                title: Text('Widget'),
                shape: InputBorder.none,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pages ${route.navigator?.widget.pages}'),
                  Text('initialRoute ${route.navigator?.widget.initialRoute}'),
                  Text(
                      'routeTraversalEdgeBehavior ${route.navigator?.widget.routeTraversalEdgeBehavior}'),
                  Text('requestFocus ${route.navigator?.widget.requestFocus}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
