import 'package:smartflowpro/app/export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartflowpro/features/auth/data/models/user_model.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';

/// Profile Screen - Riverpod Version
/// 
/// Displays and allows editing of user profile information.
/// Uses Riverpod for state management.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    // Will be updated when user data is available
    nameController = TextEditingController(text: 'John Doe');
    emailController = TextEditingController(text: 'john.doe@email.com');
    phoneController = TextEditingController(text: '+1 234 567 8901');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controllers with current user data
    final user = ref.read(currentUserProvider);
    if (user != null) {
      nameController.text = user.fullName;
      emailController.text = user.email;
      phoneController.text = user.phone ?? '+1 234 567 8901';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(profileEditingProvider);
    final String profileImage = 'https://i.pravatar.cc/150?img=3';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Profile",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: AppColors.darkText,
            ),
            onPressed: () {
              ref.read(profileEditingProvider.notifier).toggle();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isEditing
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: BuildBasicButton(
                onPressed: () async {
                  // Save profile changes
                  await ref.read(profileProvider.notifier).updateProfile(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                  ref.read(profileEditingProvider.notifier).toggle();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully')),
                  );
                },
                title: "Save",
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: profileImage,
                width: 96.w,
                height: 96.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 96.w,
                  height: 96.w,
                  color: AppColors.lightGray,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 96.w,
                  height: 96.w,
                  color: AppColors.lightGray,
                  child: Icon(
                    Icons.person,
                    size: 48.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Display user role (read-only)
            Text(
              ref.watch(currentUserProvider)?.roleText ?? 'Technician',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            CustomUnderlineTextFiled(
              label: 'Full Name',
              controller: nameController,
              keyboardType: TextInputType.name,
              obscureText: false,
              enabled: isEditing,
            ),
            SizedBox(height: 16.h),
            CustomUnderlineTextFiled(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              enabled: isEditing,
            ),
            SizedBox(height: 16.h),
            CustomUnderlineTextFiled(
              label: 'Phone Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
              obscureText: false,
              enabled: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomUnderlineTextFiled extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;

  const CustomUnderlineTextFiled({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.ubuntu(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        labelText: label,
        labelStyle: GoogleFonts.ubuntu(fontSize: 14.sp, color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor, width: 2),
        ),
      ),
    );
  }
}

