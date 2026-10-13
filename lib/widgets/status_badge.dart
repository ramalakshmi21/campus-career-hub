import 'package:flutter/material.dart';
import '../models/application_model.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    IconData icon;

    switch (status) {
      case ApplicationStatus.applied:
        bg = AppColors.infoLight;
        text = AppColors.info;
        icon = Icons.send_rounded;
        break;
      case ApplicationStatus.underReview:
        bg = AppColors.warningLight;
        text = const Color(0xFFB45309);
        icon = Icons.hourglass_top_rounded;
        break;
      case ApplicationStatus.shortlisted:
        bg = const Color(0xFFEDE9FE);
        text = AppColors.tertiary;
        icon = Icons.thumb_up_alt_rounded;
        break;
      case ApplicationStatus.interview:
        bg = const Color(0xFFE0E7FF);
        text = AppColors.primary;
        icon = Icons.event_available_rounded;
        break;
      case ApplicationStatus.selected:
        bg = AppColors.successLight;
        text = const Color(0xFF047857);
        icon = Icons.check_circle_rounded;
        break;
      case ApplicationStatus.notSelected:
        bg = AppColors.errorLight;
        text = const Color(0xFFB91C1C);
        icon = Icons.cancel_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
