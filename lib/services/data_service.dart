import 'package:flutter/material.dart';
import '../data/mock_data.dart' hide Notification;
import '../data/mock_data.dart' as mockdata show Notification;

class DataService extends ChangeNotifier {
  // Lists - mutable instead of const
  late List<LostReport> myLostReports;
  late List<FoundReport> myFoundReports;
  late List<AdminLostReport> allLostReports;
  late List<LfMatch> matches;
  late List<Issue> myIssues;
  late List<Issue> allIssues;
  late List<Event> allEvents;
  late List<Event> pendingEvents; // Events waiting for approval
  late List<Candidate> candidates;
  late List<Locker> lockers;
  late List<LockerBooking> myBookings;
  late Map<String, List<LockerHistory>> lockerHistory;
  late List<mockdata.Notification> notifications;

  DataService() {
    _initializeData();
  }

  void _initializeData() {
    myLostReports = List.from(MockData.myLostReports);
    myFoundReports = List.from(MockData.myFoundReports);
    allLostReports = List.from(MockData.allLostReports);
    matches = List.from(MockData.matches);
    myIssues = List.from(MockData.myIssues);
    allIssues = List.from(MockData.allIssues);
    allEvents = [];  // Start with empty - events are added when created and approved
    pendingEvents = [];
    candidates = List.from(MockData.candidates);
    lockers = List.from(MockData.lockers);
    myBookings = List.from(MockData.myBookings);
    lockerHistory = Map.from(MockData.lockerHistory);
    notifications = List.from(MockData.notifications);
  }

  // ── LOST & FOUND ────────────────────────────
  void addLostReport(LostReport report) {
    myLostReports.add(report);
    allLostReports.add(AdminLostReport(
      id: report.id,
      studentId: 'S001',
      title: report.title,
      category: report.category,
      whereLost: report.whereLost,
      status: report.status,
      createdDate: report.whenLost,
    ));
    _addNotification(
      'A new lost item was reported: ${report.title}',
      'admin',
    );
    notifyListeners();
  }

  void addFoundReport(FoundReport report) {
    myFoundReports.add(report);
    _addNotification(
      'A found item was reported: ${report.description}',
      'admin',
    );
    notifyListeners();
  }

  void updateLostReportStatus(String id, String newStatus) {
    final index = myLostReports.indexWhere((r) => r.id == id);
    if (index != -1) {
      myLostReports[index] = LostReport(
        id: myLostReports[index].id,
        title: myLostReports[index].title,
        category: myLostReports[index].category,
        whereLost: myLostReports[index].whereLost,
        whenLost: myLostReports[index].whenLost,
        status: newStatus,
        description: myLostReports[index].description,
        photos: myLostReports[index].photos,
        matchStatus: myLostReports[index].matchStatus,
      );
      notifyListeners();
    }
  }

  // ── ISSUES ──────────────────────────────────
  void reportIssue(Issue issue) {
    myIssues.add(issue);
    allIssues.add(issue);
    _addNotification(
      'A new issue was reported: ${issue.title}',
      'admin',
    );
    notifyListeners();
  }

  void updateIssueStatus(String id, String newStatus) {
    final index = allIssues.indexWhere((i) => i.id == id);
    if (index != -1) {
      allIssues[index] = Issue(
        id: allIssues[index].id,
        title: allIssues[index].title,
        category: allIssues[index].category,
        location: allIssues[index].location,
        status: newStatus,
        createdDate: allIssues[index].createdDate,
        updatedDate: DateTime.now().toString().split('.')[0],
        description: allIssues[index].description,
        studentId: allIssues[index].studentId,
      );
      notifyListeners();
    }
  }

  // ── EVENTS ──────────────────────────────────
  void createEvent(Event event) {
    // New events go to PENDING until admin approves
    pendingEvents.add(event);
    _addNotification(
      'A new event waiting for approval: ${event.title}',
      'admin',
    );
    notifyListeners();
  }

  void approveEvent(String id) {
    final index = pendingEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final event = pendingEvents[index];
      allEvents.add(Event(
        id: event.id,
        title: event.title,
        date: event.date,
        time: event.time,
        location: event.location,
        category: event.category,
        organizer: event.organizer,
        description: event.description,
        status: 'Published',
      ));
      pendingEvents.removeAt(index);
      _addNotification(
        'Event approved: ${event.title}',
        'campaign',
      );
      notifyListeners();
    }
  }

  void rejectEvent(String id) {
    final index = pendingEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final event = pendingEvents[index];
      _addNotification(
        'Event rejected: ${event.title}',
        'campaign',
      );
      pendingEvents.removeAt(index);
      notifyListeners();
    }
  }

  // ── NOTIFICATIONS ───────────────────────────
  void _addNotification(String message, String type) {
    final newNotif = mockdata.Notification(
      id: 'N${notifications.length + 1}',
      type: type,
      text: message,
      time: DateTime.now().toString().split('.')[0],
      read: false,
    );
    notifications.insert(0, newNotif);
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = mockdata.Notification(
        id: notifications[index].id,
        type: notifications[index].type,
        text: notifications[index].text,
        time: notifications[index].time,
        read: true,
        relatedScreen: notifications[index].relatedScreen,
        relatedId: notifications[index].relatedId,
      );
      notifyListeners();
    }
  }
}
