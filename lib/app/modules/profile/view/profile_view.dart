import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../export/exports.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController(
    text: 'John Doe',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'john.doe@email.com',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '+1 234 567 8901',
  );

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                isEditing = !isEditing;
                // Optionally save changes here when toggling off edit mode
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isEditing
          ? Padding(
              padding: EdgeInsets.all(16.w),
              child: BuildBasicButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                    // Optionally save changes here when toggling off edit mode
                  });
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
            CircleAvatar(
              radius: 48.w,
              backgroundImage: NetworkImage(profileImage),
            ),
            SizedBox(height: 24.h),
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
