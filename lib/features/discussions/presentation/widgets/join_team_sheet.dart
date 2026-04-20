import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/helpers/validator.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinTeamSheet extends StatefulWidget {
  const JoinTeamSheet({super.key});

  @override
  State<JoinTeamSheet> createState() => _JoinTeamSheetState();
}

class _JoinTeamSheetState extends State<JoinTeamSheet> {
  final Map<String, String?> _form = {
    'name': null,
    'email': null,
    'password': null,
    'mobile': null,
    "description": null,
  };
  final _formKey = GlobalKey<FormState>();
  final DiscussionController controller = Get.find<DiscussionController>();
  @override
  void dispose() {
    controller.registerRes.value = ApiResponseModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArabicText(
                  'طلب الانضمام إلى فريق المتدبرين',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                const SizedBox(height: 16),
                _inputField(
                  'اسم المستخدم',
                  onChanged: (v) => _form['name'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'اسم المستخدم', input: value),
                ),
                const SizedBox(height: 12),
                _inputField(
                  'البريد الإلكتروني',
                  onChanged: (v) => _form['email'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'البريد الإلكتروني', input: value),
                ),
                const SizedBox(height: 12),
                _inputField(
                  'كلمة المرور',
                  obscure: true,
                  onChanged: (v) => _form['password'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'كلمة المرور', input: value),
                ),
                const SizedBox(height: 12),
                _inputField(
                  'رقم الهاتف',
                  onChanged: (v) => _form['mobile'] = v,
                  isMobile: true,
                  validator: (value) =>
                      validator(isRequired: true, label: 'رقم الهاتف', input: value),
                ),
                const SizedBox(height: 12),
                _inputField(
                  'حدثنا عنك',
                  maxLines: 4,
                  // obscure: true,
                  onChanged: (v) => _form['description'] = v,
                  validator: (value) =>
                      validator(isRequired: true, label: 'حدثنا عنك', input: value),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final res = controller.registerRes.value;

                  if (res.response == ResponseEnum.failed) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ArabicText("البريد الإلكتروني مستخدم بالفعل", color: Colors.red),
                    );
                  }

                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 10),
                Obx(() {
                  final state = controller.registerRes.value.response;
                  if (state == ResponseEnum.loading) {
                    return Center(child: const CircularProgressIndicator());
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
                        final res = await controller.register(
                          name: _form['name'],
                          email: _form['email'],
                          password: _form['password'],
                          mobile: _form['mobile'],
                          description: _form['description'],
                        );
                        if (res.response == ResponseEnum.success) {
                          Get.back();
                          Get.dialog(
                            AlertDialog(
                              title: const ArabicText('تم استلام طلبك'),
                              content: const ArabicText(
                                'سيتم مراجعة طلبك من قبل الإدارة، وسيتواصل معك أحد أعضاء الفريق قريبًا لتزويدك ببيانات الدخول.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const ArabicText('حسنًا'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: ArabicText('إرسال الطلب', fontSize: 16, color: Colors.white),
                    ),
                  );
                }),
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
    int? maxLines,
    bool isMobile = false,
  }) {
    return TextFormField(
      // obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
      maxLines: maxLines,
      keyboardType: isMobile ? TextInputType.numberWithOptions() : null,
    );
  }
}
