import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMessageBar extends StatefulWidget {
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final String messageBarHintText;
  final TextStyle messageBarHintStyle;
  final TextStyle textFieldTextStyle;
  final Color sendButtonColor;
  final FocusNode focusNode;

  final void Function(String)? onSend;
  final void Function()? onTapCloseReply;

  CustomMessageBar({
    this.replyWidgetColor = const Color(0xffF4F4F5),
    this.replyIconColor = Colors.blue,
    this.replyCloseColor = Colors.black12,
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = Colors.blue,
    this.messageBarHintText = "Type your message here",
    this.messageBarHintStyle = const TextStyle(fontSize: 16),
    this.textFieldTextStyle = const TextStyle(color: Colors.black),
    this.onSend,
    this.onTapCloseReply,
    required this.focusNode,
  });

  @override
  State<CustomMessageBar> createState() => _CustomMessageBarState();
}

class _CustomMessageBarState extends State<CustomMessageBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.messageBarColor,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              "assets/icons/emoji.svg",
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: _textController,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              onChanged: (value) {
                setState(() {});
              },
              style: widget.textFieldTextStyle,
              cursorColor: AppTheme.mainColor,
              decoration: InputDecoration(
                hintText: widget.messageBarHintText,
                hintMaxLines: 1,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                hintStyle: widget.messageBarHintStyle,
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 0.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.black26,
                    width: 0.2,
                  ),
                ),
              ),
            ),
          ),
          _textController.text.trim().isEmpty
              ? IconButton(
                  onPressed: () {
                    if (_textController.text.trim() != '') {
                      if (widget.onSend != null) {
                        widget.onSend!(_textController.text.trim());
                      }
                      _textController.text = '';
                    }
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/record.svg",
                    color: AppTheme.mainColor,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    if (_textController.text.trim() != '') {
                      if (widget.onSend != null) {
                        widget.onSend!(_textController.text.trim());
                      }
                      _textController.text = '';
                    }
                  },
                  icon: Transform.rotate(
                    angle: 45 * (3.141592653589793 / 180),
                    child: SvgPicture.asset(
                      "assets/icons/send.svg",
                      color: AppTheme.mainColor,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
