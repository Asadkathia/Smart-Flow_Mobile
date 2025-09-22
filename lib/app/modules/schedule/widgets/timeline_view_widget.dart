import '../../../export/exports.dart';

class TimeLineView extends StatelessWidget {
  // Generate all times from 7:00 AM to 10:00 PM (hourly)
  final List<TimeOfDay> times = List.generate(
    16, // from 7 AM to 10 PM inclusive = 16 entries
    (index) => TimeOfDay(hour: 7 + index, minute: 0),
  );

  TimeLineView({super.key});

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour ${period}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: times.length,
      itemBuilder: (context, index) {
        final time = times[index];
        return SizedBox(
          height: 60, // row height
          child: Row(
            children: [
              // Left time label
              SizedBox(
                width: 60,
                child: Text(
                  formatTime(time),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              // Horizontal line
              Expanded(child: Container(height: 1, color: AppColors.greyColor)),
            ],
          ),
        );
      },
    );
  }
}
