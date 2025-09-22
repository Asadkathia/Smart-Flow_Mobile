
import '../../../export/exports.dart';

class HomePageController extends GetxController {
  // Observable list of scheduled jobs
  var scheduledJobs = <Job>[].obs;

  // Bottom navigation selected index
  final RxInt currentTab = 0.obs;

  void setTab(int index) => currentTab.value = index;

  @override
  void onInit() {
    super.onInit();
    // Load initial scheduled jobs (replace with actual data fetching logic)
    loadScheduledJobs();
  }

  void loadScheduledJobs() {
    // Dummy data with real Phoenix, Arizona area coordinates
    scheduledJobs.assignAll([
      Job(
        id: '1',
        jobTitle: 'LG Washer Repair',
        companyName: 'Linda Fritz-Salazar',
        address: '15244 North 11th Street, Phoenix, AZ',
        timeRange: '9:00 AM - 12:00 PM',
        startsIn: '1 hour',
        statusLabel: 'Pending',
        latitude: 33.6318, // North Phoenix area
        longitude: -112.0362,
      ),
      Job(
        id: '2',
        jobTitle: 'Samsung Refrigerator Service',
        companyName: 'John Doe',
        address: '123 Main Street, Scottsdale, AZ',
        timeRange: '1:00 PM - 3:00 PM',
        startsIn: '3 hours',
        statusLabel: 'In Progress',
        latitude: 33.4734, // Scottsdale area
        longitude: -111.8988,
      ),
      Job(
        id: '3',
        jobTitle: 'GE Oven Installation',
        companyName: 'Jane Smith',
        address: '456 Oak Avenue, Tempe, AZ',
        timeRange: '4:00 PM - 5:00 PM',
        startsIn: '6 hours',
        statusLabel: 'Completed',
        latitude: 33.4152, // Tempe area
        longitude: -111.9093,
      ),
      Job(
        id: '4',
        jobTitle: 'Dishwasher Installation',
        companyName: 'Mike Johnson',
        address: '789 Desert Road, Mesa, AZ',
        timeRange: '10:00 AM - 11:30 AM',
        startsIn: '30 minutes',
        statusLabel: 'Confirmed',
        latitude: 33.4019, // Mesa area
        longitude: -111.7174,
      ),
    ]);
  }

  // Add other controller methods as needed, e.g., for refreshing jobs, etc.
}
