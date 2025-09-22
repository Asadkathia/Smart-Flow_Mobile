import 'package:table_calendar/table_calendar.dart';
import '../../../export/exports.dart';

class DayViewWidget extends StatelessWidget {
  const DayViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        TableCalendar(
          // headerVisible: false,
          focusedDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 30)),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        ),
        Divider(color: AppColors.greyColor.withOpacity(0.5)),
        const UserStatsWidget(userName: "Tony", statsText: "5/5"),
        10.verticalSpace,
        Expanded(child: TimeLineView()),
      ],
    );
  }
}
