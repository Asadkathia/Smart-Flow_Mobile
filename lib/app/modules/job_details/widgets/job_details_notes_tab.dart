import '../../../export/exports.dart';

class JobDetailsNotesTab extends StatelessWidget {
  const JobDetailsNotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Add Note container button
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyColor.withAlpha(70),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Add Note',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Camera icon container button
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 56.h,
                width: 56.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor.withAlpha(70)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.green,
                  size: 28.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        // Notes list
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          separatorBuilder: (_, __) => SizedBox(height: 18.h),
          itemBuilder: (context, index) {
            final note = notes[index];
            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.greyColor.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note['text'],
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 16.sp),
                  ),
                  if (note['images'] != null && note['images'].isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 80.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: note['images'].length,
                        separatorBuilder: (_, __) => SizedBox(width: 10.w),
                        itemBuilder: (context, imgIdx) {
                          final imgUrl = note['images'][imgIdx];
                          return GestureDetector(
                            // onTap: () => showImageFullScreen(context, imgUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                imgUrl,
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}

// Example notes data
List<Map<String, dynamic>> get notes => [
  {
    'text': 'Washing machine leaking from the bottom after cycle.',
    'images': [
      'https://imgs.search.brave.com/pf_vHr4qiw1hCrDoCJb4iV_I3xrewekoVtTYu9YQnx8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/Ym9yZWRwYW5kYS5j/b20vYmxvZy93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMS8xMS82/MThiOTYzY2M4OWNi/X0U3VFZ4UGhfXzg4/MC5qcGc',
      'https://imgs.search.brave.com/pf_vHr4qiw1hCrDoCJb4iV_I3xrewekoVtTYu9YQnx8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/Ym9yZWRwYW5kYS5j/b20vYmxvZy93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMS8xMS82/MThiOTYzY2M4OWNi/X0U3VFZ4UGhfXzg4/MC5qcGc',
      'https://imgs.search.brave.com/pf_vHr4qiw1hCrDoCJb4iV_I3xrewekoVtTYu9YQnx8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/Ym9yZWRwYW5kYS5j/b20vYmxvZy93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMS8xMS82/MThiOTYzY2M4OWNi/X0U3VFZ4UGhfXzg4/MC5qcGc',
      'https://picsum.photos/seed/leak2/120/120',
      'https://picsum.photos/seed/leak1/120/120',
      'https://picsum.photos/seed/leak2/120/120',
      'https://picsum.photos/seed/leak1/120/120',
      'https://picsum.photos/seed/leak2/120/120',
    ],
  },
  {
    'text': 'Replaced water inlet valve. Test run successful.',
    'images': ['https://picsum.photos/seed/valve/120/120'],
  },
  {'text': 'No visible damage to drum.', 'images': []},
];

void showImageFullScreen(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    ),
  );
}
