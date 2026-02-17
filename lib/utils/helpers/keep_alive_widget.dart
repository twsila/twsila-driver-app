import 'package:flutter/material.dart';

class KeepAlivePage extends StatefulWidget {
  bool keepAlive;

  KeepAlivePage({required this.child, required this.keepAlive});

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }
  @override
  void didUpdateWidget(KeepAlivePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keepAlive != oldWidget.keepAlive) {
      updateKeepAlive();
    }
  }

  @override
  void dispose() {
    widget.keepAlive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
