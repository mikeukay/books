import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Function onScrollEndNotificationHandler;

  const CustomScaffold({Key key,
    @required this.body,
    this.onScrollEndNotificationHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 800.0,
                  ),
                  child: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification scrollNotification) {
    if(onScrollEndNotificationHandler != null && scrollNotification is ScrollEndNotification)
      onScrollEndNotificationHandler(scrollNotification);
    return false;
  }
}
