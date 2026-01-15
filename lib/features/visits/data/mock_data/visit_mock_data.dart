import '../models/visit_model.dart';
import '../models/note_model.dart';

/// Centralized Mock Data for Visits and Notes
/// 
/// This file contains all mock data used across the application.
/// Both providers and repositories should reference this file to ensure
/// data consistency across all screens.
class VisitMockData {
  VisitMockData._(); // Private constructor to prevent instantiation

  /// Get mock visits list
  /// 
  /// Returns a list of 4 mock visits with different statuses:
  /// - Visit 1: Scheduled (future)
  /// - Visit 2: In Progress (started)
  /// - Visit 3: Scheduled (future)
  /// - Visit 4: Completed (past)
  static List<VisitModel> getMockVisits() {
    final now = DateTime.now();
    return [
      VisitModel(
        id: '1',
        orgId: 'org_1',
        jobId: 'job_1',
        technicianId: 'tech_1',
        scheduledStart: now.add(const Duration(hours: 1)),
        scheduledEnd: now.add(const Duration(hours: 4)),
        status: VisitStatus.scheduled,
        createdAt: now,
        updatedAt: now,
        title: 'LG Washer Repair',
        customerName: 'Linda Fritz-Salazar',
        address: '15244 North 11th Street, Phoenix, AZ',
        latitude: 33.6318,
        longitude: -112.0362,
      ),
      VisitModel(
        id: '2',
        orgId: 'org_1',
        jobId: 'job_2',
        technicianId: 'tech_1',
        scheduledStart: now.add(const Duration(hours: 3)),
        scheduledEnd: now.add(const Duration(hours: 5)),
        status: VisitStatus.inProgress,
        actualStart: now.subtract(const Duration(minutes: 30)),
        createdAt: now,
        updatedAt: now,
        title: 'Samsung Refrigerator Service',
        customerName: 'John Doe',
        address: '123 Main Street, Scottsdale, AZ',
        latitude: 33.4734,
        longitude: -111.8988,
      ),
      VisitModel(
        id: '3',
        orgId: 'org_1',
        jobId: 'job_3',
        technicianId: 'tech_1',
        scheduledStart: now.add(const Duration(hours: 6)),
        scheduledEnd: now.add(const Duration(hours: 7)),
        status: VisitStatus.scheduled,
        createdAt: now,
        updatedAt: now,
        title: 'GE Oven Installation',
        customerName: 'Jane Smith',
        address: '456 Oak Avenue, Tempe, AZ',
        latitude: 33.4152,
        longitude: -111.9093,
      ),
      VisitModel(
        id: '4',
        orgId: 'org_1',
        jobId: 'job_4',
        technicianId: 'tech_1',
        scheduledStart: now.subtract(const Duration(hours: 2)),
        scheduledEnd: now.subtract(const Duration(minutes: 30)),
        status: VisitStatus.completed,
        actualStart: now.subtract(const Duration(hours: 2)),
        actualEnd: now.subtract(const Duration(minutes: 30)),
        createdAt: now,
        updatedAt: now,
        title: 'Dishwasher Installation',
        customerName: 'Mike Johnson',
        address: '789 Desert Road, Mesa, AZ',
        latitude: 33.4019,
        longitude: -111.7174,
        notes: 'Service completed successfully. Customer satisfied with the work.',
      ),
    ];
  }

  /// Get mock visit details by ID
  /// 
  /// Returns a visit with additional details like customerPhone and notes.
  /// If visitId is not found, returns the first visit from the mock list.
  static VisitModel getMockVisitDetails(String visitId) {
    final now = DateTime.now();
    final mockVisits = getMockVisits();
    
    // Try to find visit by ID
    try {
      final existingVisit = mockVisits.firstWhere((v) => v.id == visitId);
      
      // Return visit with additional details
      return existingVisit.copyWith(
        actualStart: existingVisit.status == VisitStatus.inProgress || 
                     existingVisit.status == VisitStatus.completed
            ? existingVisit.actualStart ?? existingVisit.scheduledStart.add(const Duration(minutes: 15))
            : null,
        actualEnd: existingVisit.status == VisitStatus.completed
            ? existingVisit.actualEnd ?? existingVisit.scheduledStart.add(const Duration(hours: 2, minutes: 15))
            : null,
        customerPhone: '+1 (555) ${1000 + (int.tryParse(visitId) ?? 1)}-${5678 + (int.tryParse(visitId) ?? 1)}',
        notes: existingVisit.status == VisitStatus.completed
            ? existingVisit.notes ?? 'Service completed successfully. Customer satisfied with the work.'
            : null,
      );
    } catch (_) {
      // If visit not found, return first visit with modified ID
      if (mockVisits.isNotEmpty) {
        return mockVisits.first.copyWith(
          id: visitId,
          actualStart: now.subtract(const Duration(minutes: 15)),
          customerPhone: '+1 (555) 123-4567',
        );
      }
      
      // Fallback: create a default visit
      return VisitModel(
        id: visitId,
        orgId: 'org_1',
        jobId: 'job_1',
        technicianId: 'tech_1',
        scheduledStart: now.add(const Duration(hours: 1)),
        scheduledEnd: now.add(const Duration(hours: 4)),
        status: VisitStatus.scheduled,
        createdAt: now,
        updatedAt: now,
        title: 'Service Visit',
        customerName: 'Customer Name',
        address: '123 Main Street, Phoenix, AZ',
        customerPhone: '+1 (555) 123-4567',
        latitude: 33.4484,
        longitude: -112.0740,
      );
    }
  }

  /// Get mock notes for a visit
  /// 
  /// Returns a list of 3 mock notes with different timestamps.
  /// All notes are associated with the provided visitId.
  static List<NoteModel> getMockNotes(String visitId) {
    final now = DateTime.now();
    return [
      NoteModel(
        id: 'note_1',
        orgId: 'org_1',
        visitId: visitId,
        authorId: 'tech_1',
        body: 'Customer requested a follow-up on compressor noise. Checked the unit and found loose mounting bolts.', // PRD: body (not content)
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      NoteModel(
        id: 'note_2',
        orgId: 'org_1',
        visitId: visitId,
        authorId: 'tech_1',
        body: 'Replaced faulty capacitor. System now running smoothly. Customer informed about maintenance schedule.', // PRD: body (not content)
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      NoteModel(
        id: 'note_3',
        orgId: 'org_1',
        visitId: visitId,
        authorId: 'tech_1',
        body: 'Initial inspection completed. Found issue with the main control board. Parts ordered.', // PRD: body (not content)
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}



