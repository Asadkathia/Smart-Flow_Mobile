import '../export/exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final bool centerTitle;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false, // Disable default back button
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: titleColor ?? AppColors.blackColor,
                size: 20.sp,
              ),
              onPressed: () => Get.back(),
            )
          : null,
      title: Text(
        title,
        style:
            titleStyle ??
            AppTextStyles.appBarTitle.copyWith(
              color: titleColor ?? AppColors.blackColor,
              fontSize: 26.sp,
            ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
