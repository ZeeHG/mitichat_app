import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OperateType {
  forward,
  save,
}

class PhotoBrowserBottomBar extends StatelessWidget {
  PhotoBrowserBottomBar({Key? key}) : super(key: key);
  ValueChanged<OperateType>? _onPressedButton;

  PhotoBrowserBottomBar.show(BuildContext context, {ValueChanged<OperateType>? onPressedButton}) {
    _onPressedButton = onPressedButton;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return PhotoBrowserBottomBar();
        });
  }
  @override
  Widget build(BuildContext context) {
    return _buildBar(context);
  }

  Widget _buildBar(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 160),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(Icon(Icons.screen_share_outlined), 'forward', onPressed: () {
                _onPressedButton?.call(OperateType.forward);
              }),
              _buildItem(Icon(Icons.save_alt), 'save', onPressed: () {
                _onPressedButton?.call(OperateType.save);
              })
            ],
          ),
          Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Icon icon, String title, {VoidCallback? onPressed}) {
    return Column(children: [
      CupertinoButton(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Container(
            decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
            child: icon,
            height: 60,
            width: 60,
          ),
          onPressed: () {
            onPressed?.call();
          }),
      Text(
        title,
        textAlign: TextAlign.center,
      )
    ]);
  }
}
