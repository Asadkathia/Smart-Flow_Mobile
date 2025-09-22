class Job {
  final String id;
  final String jobTitle;
  final String companyName;
  final String address;
  final String timeRange;
  final String startsIn;
  final String statusLabel;
  final double latitude;
  final double longitude;

  Job({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.address,
    required this.timeRange,
    required this.startsIn,
    required this.statusLabel,
    required this.latitude,
    required this.longitude,
  });
}
