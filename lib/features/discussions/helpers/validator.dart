String? validator({
  required String? input,
  required String label,
  required bool isRequired,
  int? minChars,
  int? maxChars,
  bool isEmail = false,
  bool isConfirmPassword = false,
  String? firstPassword,
}) {
  final value = input?.trim() ?? '';

  if (isRequired && value.isEmpty) {
    return 'حقل $label مطلوب';
  }

  if (minChars != null && value.length < minChars) {
    return 'حقل $label يجب ألا يقل عن $minChars أحرف';
  }

  if (maxChars != null && value.length > maxChars) {
    return 'حقل $label يجب ألا يزيد عن $maxChars أحرف';
  }

  if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'البريد الإلكتروني غير صالح';
  }

  if (isConfirmPassword && value != firstPassword) {
    return 'تأكيد كلمة المرور غير متطابق';
  }

  return null;
}
