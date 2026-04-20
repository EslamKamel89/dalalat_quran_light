import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/widgets/discussion_card.dart';
import 'package:dalalat_quran_light/ui/intro_screen.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final DiscussionController controller = Get.find<DiscussionController>();

  @override
  void initState() {
    controller.discussions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: QuranBar("المجلس"),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ArabicText(
                      'مرحباً ${user?.name ?? ''}',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'logout',
                        child: ArabicText('تسجيل الخروج'),
                        onTap: () {
                          logout();
                          Get.offAll(IntroScreen());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final state = controller.discussionsRes.value;
                if (state.response == ResponseEnum.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if ((state.data ?? []).isEmpty) {
                  return Center(
                    child: ArabicText(
                      'لا توجد مواضيع بعد',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return DiscussionCard(discussion: (state.data ?? [])[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
