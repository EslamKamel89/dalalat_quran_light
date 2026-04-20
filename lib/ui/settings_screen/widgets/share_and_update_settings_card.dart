import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareAndUpdateSettingsCard extends StatefulWidget {
  const ShareAndUpdateSettingsCard({super.key});

  @override
  State<ShareAndUpdateSettingsCard> createState() => _ShareAndUpdateSettingsCardState();
}

class _ShareAndUpdateSettingsCardState extends State<ShareAndUpdateSettingsCard> {
  final SettingsController _controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: lightGray,
        // borderRadius: BorderRadius.circular(14),
        // boxShadow: [
        //   BoxShadow(
        //     color: mediumGray.withOpacity(0.2),
        //     blurRadius: 8,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          _SettingRow(
            label: "show_app_details_on_share".tr,
            value: _controller.showAppDetails,
            onChanged: (v) => setState(() => _controller.showAppDetails = v),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: lightGray2,
          ),
          _SettingRow(
            label: "notify_new_update".tr,
            value: _controller.showNotifications,
            onChanged: (v) => setState(() => _controller.showNotifications = v),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingRow({super.key, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Almarai',
            ),
            textAlign: TextAlign.right,
          ),
          Spacer(),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: primaryColor,
            inactiveTrackColor: lightGray2,
            inactiveThumbColor: mediumGray,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
