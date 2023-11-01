import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChannelMessageBar extends StatefulWidget {
  final Color messageBarColor;
  final String messageBarHintText;
  final TextStyle messageBarHintStyle;
  final TextStyle textFieldTextStyle;
  final Color sendButtonColor;
  final FocusNode focusNode;
  final String channelUid;

  ChannelMessageBar({
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = Colors.blue,
    this.messageBarHintText = "Type your message here",
    this.messageBarHintStyle = const TextStyle(fontSize: 16),
    this.textFieldTextStyle = const TextStyle(color: Colors.black),
    required this.channelUid,
    required this.focusNode,
  });

  @override
  State<ChannelMessageBar> createState() => _ChannelMessageBarState();
}

class _ChannelMessageBarState extends State<ChannelMessageBar> {
  final TextEditingController _textController = TextEditingController();
  ChatController chatController = Get.put(ChatController());
  String rawMessageText = '';

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
            onTap: () async {},
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
                rawMessageText = value;
              },
              style: widget.textFieldTextStyle,
              cursorColor: AppTheme.mainColor,
              
              decoration: InputDecoration(
                labelStyle: GoogleFonts.lato(fontSize: 15),
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
                      _textController.text = '';
                    }
                  },
                  icon: SvgPicture.asset(
                   CustomIcons.selectImage,
                    colorFilter: const ColorFilter.mode(
                        AppTheme.mainColor, BlendMode.srcIn),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    if (_textController.text.trim() != '') {}
                    _textController.text = '';
                  },
                  //Send file
                  icon: Transform.rotate(
                    angle: 45 * (3.141592653589793 / 180),
                    child: SvgPicture.asset(
                    CustomIcons.send,
                      colorFilter: const ColorFilter.mode(
                          AppTheme.mainColor, BlendMode.srcIn),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
