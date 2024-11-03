import 'package:flutter/material.dart';

class EditableTitle extends StatefulWidget {
  final String value;
  final Future<String?> Function(BuildContext, String) validate;
  final void Function(String) onConfirm;
  
  const EditableTitle({required this.value, required this.validate, required this.onConfirm, super.key});

  @override
  State<EditableTitle> createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  late final controller = TextEditingController(text: widget.value);
  final focusNode = FocusNode();
  var isChanged = false;
  String? errorMessage;
  bool isEditing = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isEditing) {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isEditing = true;
                });
              },
              child: Text(widget.value, style: theme.textTheme.titleLarge)
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            )
          ],
        ),
      );
    }

    final errorMessage = this.errorMessage;
    return TextField(
      controller: controller,
      autofocus: true,
      style: theme.textTheme.titleLarge,
      focusNode: focusNode,
      onChanged: (newValue) async {
        final errMsg = await widget.validate(context, newValue);
        setState(() {
          isChanged = newValue != widget.value;
          this.errorMessage = errMsg;
        });
      },
      decoration: InputDecoration(
          //labelText: widget.label,
          errorText: errorMessage,
          border: InputBorder.none,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.text = widget.value;
                  setState(() {
                    isEditing = false;
                    this.errorMessage = null;
                  });
                  
                },
              ),
              if (errorMessage == null) IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  final newValue = controller.text.trim();
                  widget.onConfirm(newValue);
                  setState(() {
                    isEditing = false;
                  });
                  focusNode.unfocus();
                },
              )
            ],
          )
      ),
    );
  }
}