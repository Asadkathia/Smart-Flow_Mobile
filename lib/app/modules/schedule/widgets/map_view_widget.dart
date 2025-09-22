import '../../../export/exports.dart';

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomePageController>();
    return Column(
      children: [
        TableCalendar(
          calendarFormat: CalendarFormat.week,
          focusedDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 30)),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
        ),
        const UserStatsWidget(userName: "Tony", statsText: "5/5"),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Map
              MapWidget(jobs: homeController.scheduledJobs),
              // Fade overlays (top & bottom)
              IgnorePointer(
                child: Column(
                  children: [
                    // Top fade
                    Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.backgroundColor,
                            AppColors.backgroundColor.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Bottom fade
                    Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.backgroundColor,
                            AppColors.backgroundColor.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
