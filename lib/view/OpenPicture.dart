import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screen/screen.dart';
import 'package:somos/view/default/my_const.dart';

import 'default/my_functions.dart';

class OpenPicture extends StatefulWidget {
  OpenPicture({
    @required this.avatarUrl,
  });

  final String avatarUrl;

  @override
  _OpenPictureState createState() => _OpenPictureState();
}

class _OpenPictureState extends State<OpenPicture> {
  double _brightness = 1;

  @override
  void initState() {
    super.initState();

    Screen.brightness.then(
      (_) async {
        _brightness = await Screen.brightness;
        Screen.setBrightness(1);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Screen.setBrightness(_brightness);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Visualizar Foto"),
            backgroundColor: Color(BG_COLOR_DEFAULT),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: screenSize(context).width,
                    height: screenSize(context).height -
                        safeAreaSize(context).top -
                        56,
                    child: PhotoView(
                      imageProvider: NetworkImage(widget.avatarUrl),
                      backgroundDecoration:
                          BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
