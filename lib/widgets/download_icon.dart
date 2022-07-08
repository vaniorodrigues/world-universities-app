import 'package:flutter/material.dart';

class DownloadIcon extends StatelessWidget {
  final int isLocalDataAvailable;
  const DownloadIcon(
    this.isLocalDataAvailable, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.download_for_offline_rounded,
        color: (isLocalDataAvailable == 1) ? Colors.green : Colors.grey,
        size: 24);
  }
}
