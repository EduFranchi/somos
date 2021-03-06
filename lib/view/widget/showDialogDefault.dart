import 'package:flutter/material.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';

class ShowDialogDefault {
  ShowDialogDefault({
    @required BuildContext context,
    String title,
    Widget content,
    List<Map<String, dynamic>> buttonList,
    bool barrierDismissible = true,
  }) {
    _context = context;
    _title = title;
    _content = content;
    _buttonList = buttonList;
    _barrierDismissible = barrierDismissible;
  }

  BuildContext _context;

  String _title;

  Widget _content;

  List<Map<String, dynamic>> _buttonList;

  bool _barrierDismissible;

  dynamic build() {
    return showDialog(
      context: _context,
      barrierDismissible: _barrierDismissible, // fechar ao clicar fora
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: _content,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          actionsPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          titlePadding: EdgeInsets.only(top: 20),
          actions: _buildButtonList(contextDialog),
        );
      },
    );
  }

  List<Widget> _buildButtonList(BuildContext contextDialog) {
    List<Widget> list = new List<Widget>();

    int length = _buttonList.length > 2 ? 2 : _buttonList.length;
    for (int i = 0; i < length; i++) {
      Widget item = Container(
        height: 40,
        width: 110,
        child: Container(
          child: FlatButton(
            color: _buttonList[i]["type"] == 0
                ? Colors.white
                : Color(BG_COLOR_DEFAULT),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Color(BG_COLOR_DEFAULT),
                width: 2,
              ),
            ),
            child: Text(
              _buttonList[i]["text"].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _buttonList[i]["type"] == 0
                    ? Color(BG_COLOR_DEFAULT)
                    : Colors.white,
              ),
            ),
            onPressed: _buttonList[i]["dismissBefore"]
                ? () {
                    Navigator.pop(contextDialog);
                  }
                : () {
                    _buttonList[i]["onTap"].call();
                    if (_buttonList[i]["dismissAfter"]) {
                      Navigator.pop(contextDialog);
                    }
                  },
          ),
        ),
      );

      list.add(item);
    }

    Widget component = Container(
      width: screenSize(_context).width,
      child: Row(
        mainAxisAlignment: length == 1
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: list,
      ),
    );

    return <Widget>[component];
  }
}
