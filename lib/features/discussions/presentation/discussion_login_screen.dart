import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/helpers/validator.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/topics_screen.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/widgets/join_team_sheet.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscussionsLoginScreen extends StatefulWidget {
  const DiscussionsLoginScreen({super.key});

  @override
  State<DiscussionsLoginScreen> createState() => _DiscussionsLoginScreenState();
}

class _DiscussionsLoginScreenState extends State<DiscussionsLoginScreen> {
  final Map<String, String?> _form = {'email': null, 'password': null};

  final _formKey = GlobalKey<FormState>();
  final DiscussionController controller = Get.find<DiscussionController>();
  @override
  void dispose() {
    controller.loginRes.value = ApiResponseModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: QuranBar("النقاشات"),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ArabicText(
                  'مرحبًا بعودتك',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                const SizedBox(height: 32),
                _inputField(
                  'البريد الإلكتروني',
                  onChanged: (v) => _form['email'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'البريد الإلكتروني', input: value),
                ),
                const SizedBox(height: 16),
                _inputField(
                  'كلمة المرور',
                  obscure: true,
                  onChanged: (v) => _form['password'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'كلمة المرور', input: value),
                ),

                const SizedBox(height: 12),
                Obx(() {
                  final res = controller.loginRes.value;

                  if (res.response == ResponseEnum.failed) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'بيانات تسجيل الدخول غير صحيحة',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 12),

                Obx(() {
                  final state = controller.loginRes.value.response;
                  if (state == ResponseEnum.loading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final res = await controller.login(_form['email'], _form['password']);
                        if (res.response == ResponseEnum.success) {
                          Get.off(() => const TopicsScreen());
                        }
                      },
                      child: ArabicText('تسجيل الدخول', fontSize: 16, color: Colors.white),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Get.bottomSheet(const JoinTeamSheet());
                  },
                  child: const ArabicText(
                    'انضم إلى فريق المتدبرين',
                    color: primaryColor2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label, {
    bool obscure = false,
    required void Function(String) onChanged,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
