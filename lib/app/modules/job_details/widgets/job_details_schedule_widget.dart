import '../../../export/exports.dart';

class JobDetailsScheduleWidget extends StatelessWidget {
  const JobDetailsScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Aug 29, 9:00 AM – 12:00 PM',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
        ),
        Text(
          'Arriving between 9:00 AM – 12:00 PM',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            // Start Timer button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.play_circle_outline, color: Colors.white),
                label: Text(
                  'Start Timer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Completed button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.check, color: Colors.white),
                label: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // More button
            SizedBox(
              height: 48.h,
              width: 48.h,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                  padding: EdgeInsets.zero,
                ),
                child: Icon(Icons.more_horiz, color: Colors.black87),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
