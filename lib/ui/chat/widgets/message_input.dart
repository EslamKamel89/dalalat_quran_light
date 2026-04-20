import 'package:dalalat_quran_light/features/record/presentation/press_and_hold_recorder.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';

FocusNode chatInputFocusNode = FocusNode();
typedef OnSendMessage = void Function(String text);

class MessageInput extends StatefulWidget {
  final OnSendMessage onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              autofocus: false,
              focusNode: chatInputFocusNode,
              // canRequestFocus: false,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "اكتب سؤالك هنا...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                controller.clear();
                widget.onSend(text);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          PressAndHoldRecorder(
            onTranscriptReady: (transcript) {
              controller.text = transcript.trim();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
