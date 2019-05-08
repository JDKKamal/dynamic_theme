
import 'package:dynamic_theme/presentation/colorful_app.dart';
import 'package:dynamic_theme/presentation/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class App extends StatelessWidget {

  final String _title = 'Dynamic Theme';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ColorfulApp(
      builder: (context, theme) {
        return MaterialApp(
          title: _title,
          theme: theme,
          debugShowCheckedModeBanner: false, // removes debug ribbon
          home: HomeScreen(title: _title),
        );
      },
    );
  }
}
