import 'package:dalalat_quran_light/features/chat/controller/chat_controller.dart';
import 'package:dalalat_quran_light/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:dalalat_quran_light/features/chat/presentation/widgets/chat_histroy_drawer.dart';
import 'package:dalalat_quran_light/ui/chat/widgets/message_input.dart';
import 'package:dalalat_quran_light/utils/assets.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const id = '/ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late ChatController controller;
  @override
  void initState() {
    controller = Get.find<ChatController>();
    _scrollToBottom();
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(title: Text("دلالات شات"), backgroundColor: primaryColor),
              backgroundColor: Colors.white,
              endDrawer: ChatHistoryDrawer(
                onChatSelection: () {
                  _scrollToBottom();
                },
              ),
              body: Stack(
                children: [
                  Opacity(
                        opacity: 0.07,
                        child: Image.asset(
                          AssetsData.chatBackground,
                          width: context.width,
                          height: context.height,
                          fit: BoxFit.cover,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .moveY(duration: 10000.ms, begin: -20, end: 20)
                      .then()
                      .moveY(duration: 10000.ms, begin: 20, end: -20),
                  GetBuilder<ChatController>(
                    // listener: (context, state) {
                    // _scrollToBottom();
                    // },
                    builder: (controller) {
                      if (controller.state.messages.lastOrNull?.isTyping == true) {
                        _scrollToBottom();
                      }

                      final state = controller.state;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                        child: Column(
                          children: [
                            if (state.messages.isNotEmpty)
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: state.messages.length,
                                  itemBuilder: (context, index) {
                                    final message = state.messages[index];
                                    return ChatBubble(
                                      message: message,
                                      animate: state.messages.length - 1 == index,
                                    );
                                  },
                                ),
                              ),
                            if (state.messages.isEmpty)
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "اطرح سؤالاً",
                                    style: TextStyle(fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                              ),
                            MessageInput(
                              onSend: (text) {
                                controller.sendMessage(text);
                                chatInputFocusNode.unfocus();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
