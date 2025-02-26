import 'package:flutter/cupertino.dart';

import '../../core/constants/text_widget.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const TextWidget(
            textKey: 'cancel',
          ),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const TextWidget(
            textKey: 'confirm',
          ),
        ),
      ],
    );
  }
}
