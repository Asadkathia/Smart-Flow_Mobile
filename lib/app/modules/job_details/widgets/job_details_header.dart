import 'package:go_router/go_router.dart';
import '../../../export/exports.dart';
import '../../../../router/app_router.dart';

class JobDetailsHeader extends StatelessWidget {
  const JobDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status row: Truck icon, green dot, "Completed"
        Row(
          children: [
            Icon(Icons.delivery_dining, color: Colors.green), // Truck icon
            SizedBox(width: 8.w),
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Completed',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10.h), // Spacing
        // Visit title
        Text(
          'Visit for Scott Martin',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        // Item/Service
        Text(
          'Samsung washer',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h), // Spacing
        // Address
        Text(
          '1290 East Springfield Place\nChandler, Arizona 85286',
          style: AppTextStyles.bodyMedium,
        ),
        SizedBox(height: 10.h), // Spacing
        // Buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Directions button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.directions, size: 20.0, color: Colors.black87),
                label: Text(
                  'Directions',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(width: 16.w), // Spacing between buttons
            // On my way button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to on my way screen
                  context.goToOnMyWay(
                    visitId: '', // TODO: Pass actual visitId
                    customerName: 'Scott Martin',
                    address: '1290 East Springfield Place, Chandler, Arizona 85286',
                    latitude: 33.3062,
                    longitude: -111.8413,
                  );
                },
                icon: Icon(
                  Icons.delivery_dining,
                  size: 20.0,
                  color: Colors.black87,
                ),
                label: Text(
                  'On my way',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
