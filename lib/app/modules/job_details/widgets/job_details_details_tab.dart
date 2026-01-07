import '../../../export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';
import '../../../../features/visits/presentation/providers/job_details_provider.dart';
import '../../../../features/visits/data/models/visit_model.dart';

class JobDetailsDetailsTab extends ConsumerWidget {
  const JobDetailsDetailsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitId = ref.watch(selectedVisitIdProvider);
    
    // Fallback: use first visit from today's visits if no visitId
    final todayVisits = ref.watch(todayVisitsProvider).value;
    final effectiveVisitId = visitId ?? (todayVisits?.isNotEmpty == true ? todayVisits!.first.id : null);
    
    if (effectiveVisitId == null) {
      return Center(
        child: Text(
          'No visit selected',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyColor),
        ),
      );
    }

    final visitAsync = ref.watch(visitDetailsProvider(effectiveVisitId));
    
    return visitAsync.when(
      data: (visit) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (visit.customerName != null) ...[
            _buildCustomerInfo(context, visit),
            SizedBox(height: 20.h),
          ],
          if (visit.address != null) ...[
            _buildPropertyInfo(context, visit),
            SizedBox(height: 20.h),
          ],
          _buildJobInfo(context, visit),
          SizedBox(height: 100.h), // Bottom padding
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading details: $error',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context, VisitModel visit) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Customer Information',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (visit.customerName != null)
            _buildInfoRow('Name', visit.customerName!),
          if (visit.customerPhone != null) ...[
            _buildInfoRow('Phone', visit.customerPhone!),
            SizedBox(height: 8.h),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement phone call functionality
                // Requires url_launcher package
                final phone = visit.customerPhone;
                if (phone != null) {
                  // Launch phone dialer
                  // final uri = Uri.parse('tel:$phone');
                  // await launchUrl(uri);
                }
              },
              icon: Icon(Icons.phone, size: 18.sp, color: AppColors.primaryColor),
              label: Text(
                'Call Customer',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPropertyInfo(BuildContext context, VisitModel visit) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Property Information',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (visit.address != null)
            _buildInfoRow('Address', visit.address!),
          if (visit.latitude != null && visit.longitude != null)
            _buildInfoRow('Coordinates', '${visit.latitude}, ${visit.longitude}'),
        ],
      ),
    );
  }

  Widget _buildJobInfo(BuildContext context, VisitModel visit) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Visit Information',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('Visit ID', visit.id),
          _buildInfoRow('Job ID', visit.jobId),
          _buildInfoRow('Status', visit.statusText),
          if (visit.statusReason != null)
            _buildInfoRow('Status Reason', visit.statusReason!),
          if (visit.notes != null)
            _buildInfoRow('Notes', visit.notes!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}