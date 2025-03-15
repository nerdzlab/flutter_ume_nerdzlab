import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class ChannelPages extends StatefulWidget {
  const ChannelPages({
    Key? key,
    required this.child,
    required this.switched,
  }) : super(key: key);

  final Widget child;
  final bool switched;

  @override
  State<ChannelPages> createState() => _ChannelPagesState();
}

class _ChannelPagesState extends State<ChannelPages> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: widget.switched,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (_) => widget.child,
    );
  }
}
