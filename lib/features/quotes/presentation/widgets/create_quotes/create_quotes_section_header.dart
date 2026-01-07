import 'package:smartflowpro/app/export/exports.dart';

class CreateQuotesSectionHeader extends StatelessWidget {
  final String title;
  final String? bookLink;
  final VoidCallback? onBookTap;

  const CreateQuotesSectionHeader({
    super.key,
    required this.title,
    this.bookLink,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.captionBold.copyWith(
              color: AppColors.neutralDarkGray,
              letterSpacing: 0.5,
            ),
          ),
          if (bookLink != null)
            GestureDetector(
              onTap: onBookTap,
              child: Row(
                children: [
                  Icon(Icons.menu_book, size: 16.sp, color: AppColors.skyAqua),
                  SizedBox(width: 4.w),
                  Text(
                    bookLink!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.skyAqua,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

