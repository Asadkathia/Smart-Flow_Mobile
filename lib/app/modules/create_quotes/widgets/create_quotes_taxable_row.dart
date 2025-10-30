import '../../../export/exports.dart';

class CreateQuotesTaxableRow extends StatelessWidget {
  final bool isTaxable;
  final ValueChanged<bool> onChanged;

  const CreateQuotesTaxableRow({
    super.key,
    required this.isTaxable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGray.withOpacity(0.3), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Taxable',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
          ),
          Switch(
            value: isTaxable,
            onChanged: onChanged,
            activeColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }
}
