import 'dart:math';
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
  late List<StudentRegistration> pendingRegistrations;

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
    allEvents = List.from(MockData.events);  // Pre-populate with published events
    pendingEvents = [];
    candidates = List.from(MockData.candidates);
    lockers = List.from(MockData.lockers);
    myBookings = List.from(MockData.myBookings);
    lockerHistory = Map.from(MockData.lockerHistory.map((k, v) => MapEntry(k, List<LockerHistory>.from(v))));
    notifications = List.from(MockData.notifications);
    pendingRegistrations = List.from(MockData.pendingRegistrations);
  }

  // ── LOST & FOUND ────────────────────────────────────────────────
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
    }
    // Also update allLostReports (admin list)
    final adminIndex = allLostReports.indexWhere((r) => r.id == id);
    if (adminIndex != -1) {
      final r = allLostReports[adminIndex];
      allLostReports[adminIndex] = AdminLostReport(
        id: r.id, studentId: r.studentId, title: r.title,
        category: r.category, whereLost: r.whereLost,
        status: newStatus, createdDate: r.createdDate,
        aiScore: r.aiScore, matchedFoundId: r.matchedFoundId,
      );
    }
    notifyListeners();
  }

  void updateAdminLostReportStatus(String id, String newStatus) {
    final index = allLostReports.indexWhere((r) => r.id == id);
    if (index != -1) {
      final r = allLostReports[index];
      allLostReports[index] = AdminLostReport(
        id: r.id, studentId: r.studentId, title: r.title,
        category: r.category, whereLost: r.whereLost,
        status: newStatus, createdDate: r.createdDate,
        aiScore: r.aiScore, matchedFoundId: r.matchedFoundId,
      );
    }
    // Also sync student's myLostReports
    final myIndex = myLostReports.indexWhere((r) => r.id == id);
    if (myIndex != -1) {
      final r = myLostReports[myIndex];
      myLostReports[myIndex] = LostReport(
        id: r.id, title: r.title, category: r.category,
        whereLost: r.whereLost, whenLost: r.whenLost,
        status: newStatus, description: r.description,
        photos: r.photos, matchStatus: r.matchStatus,
      );
    }
    _addNotification('Lost report $id status updated to $newStatus', 'personal');
    notifyListeners();
  }

  void updateFoundReportStatus(String id, String newStatus) {
    final index = myFoundReports.indexWhere((r) => r.id == id);
    if (index != -1) {
      final r = myFoundReports[index];
      myFoundReports[index] = FoundReport(
        id: r.id, description: r.description, category: r.category,
        whereFound: r.whereFound, whenFound: r.whenFound,
        status: newStatus, photos: r.photos,
        handoverStatus: r.handoverStatus, qrCode: r.qrCode, qrScanned: r.qrScanned,
      );
    }
    _addNotification('Found report $id status updated to $newStatus', 'personal');
    notifyListeners();
  }

  // ── QR Code: Admin generates one-time QR for found item receive ──
  String generateReceiveQR(String foundReportId) {
    final code = 'RCV-${foundReportId}-${Random().nextInt(999999).toString().padLeft(6, '0')}';
    final index = myFoundReports.indexWhere((r) => r.id == foundReportId);
    if (index != -1) {
      final r = myFoundReports[index];
      myFoundReports[index] = FoundReport(
        id: r.id, description: r.description, category: r.category,
        whereFound: r.whereFound, whenFound: r.whenFound,
        status: r.status, photos: r.photos,
        handoverStatus: 'Pending Handover', qrCode: code, qrScanned: false,
      );
    }
    notifyListeners();
    return code;
  }

  // Student scans QR code to confirm handover
  bool scanReceiveQR(String foundReportId, String qrCode) {
    final index = myFoundReports.indexWhere((r) => r.id == foundReportId);
    if (index != -1) {
      final r = myFoundReports[index];
      if (r.qrCode == qrCode && !r.qrScanned) {
        myFoundReports[index] = FoundReport(
          id: r.id, description: r.description, category: r.category,
          whereFound: r.whereFound, whenFound: r.whenFound,
          status: 'Received', photos: r.photos,
          handoverStatus: 'Handed Over', qrCode: r.qrCode, qrScanned: true,
        );
        _addNotification('Item ${r.description} has been handed over successfully.', 'personal');
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Admin generates handover QR (for claiming student)
  String generateHandoverQR(String foundReportId) {
    final code = 'HND-${foundReportId}-${Random().nextInt(999999).toString().padLeft(6, '0')}';
    final index = myFoundReports.indexWhere((r) => r.id == foundReportId);
    if (index != -1) {
      final r = myFoundReports[index];
      myFoundReports[index] = FoundReport(
        id: r.id, description: r.description, category: r.category,
        whereFound: r.whereFound, whenFound: r.whenFound,
        status: 'Claiming', photos: r.photos,
        handoverStatus: 'Claiming', qrCode: code, qrScanned: false,
      );
    }
    _addNotification('Handover QR generated for found item $foundReportId', 'admin');
    notifyListeners();
    return code;
  }

  void completeHandover(String foundReportId) {
    final index = myFoundReports.indexWhere((r) => r.id == foundReportId);
    if (index != -1) {
      final r = myFoundReports[index];
      myFoundReports[index] = FoundReport(
        id: r.id, description: r.description, category: r.category,
        whereFound: r.whereFound, whenFound: r.whenFound,
        status: 'Resolved', photos: r.photos,
        handoverStatus: 'Claimed', qrCode: null, qrScanned: true,
      );
    }
    _addNotification('Found item $foundReportId has been claimed and resolved.', 'personal');
    notifyListeners();
  }

  // ── ISSUES ──────────────────────────────────────────────────────
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
    // Update in allIssues (admin list)
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
    }
    // ALSO sync to myIssues (student view) - BUG FIX
    final myIndex = myIssues.indexWhere((i) => i.id == id);
    if (myIndex != -1) {
      myIssues[myIndex] = Issue(
        id: myIssues[myIndex].id,
        title: myIssues[myIndex].title,
        category: myIssues[myIndex].category,
        location: myIssues[myIndex].location,
        status: newStatus,
        createdDate: myIssues[myIndex].createdDate,
        updatedDate: DateTime.now().toString().split('.')[0],
        description: myIssues[myIndex].description,
        studentId: myIssues[myIndex].studentId,
      );
    }
    _addNotification('Issue $id status updated to $newStatus', 'personal');
    notifyListeners();
  }

  void deleteIssue(String id) {
    allIssues.removeWhere((i) => i.id == id);
    myIssues.removeWhere((i) => i.id == id);
    _addNotification('Issue $id has been deleted.', 'admin');
    notifyListeners();
  }

  // ── EVENTS ──────────────────────────────────────────────────────
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
        hostStudentId: event.hostStudentId,
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

  void markEventCompleted(String id) {
    final index = allEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final e = allEvents[index];
      allEvents[index] = Event(
        id: e.id, title: e.title, date: e.date, time: e.time,
        location: e.location, category: e.category, organizer: e.organizer,
        description: e.description, status: 'Completed', hostStudentId: e.hostStudentId,
      );
      _addNotification('Event "${e.title}" has been marked as completed.', 'campaign');
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    final event = allEvents.firstWhere((e) => e.id == id, orElse: () =>
      const Event(id:'',title:'',date:'',time:'',location:'',category:'',organizer:'',description:'',status:''));
    allEvents.removeWhere((e) => e.id == id);
    pendingEvents.removeWhere((e) => e.id == id);
    if (event.title.isNotEmpty) {
      _addNotification('Event "${event.title}" has been deleted.', 'admin');
    }
    notifyListeners();
  }

  void updateEventStatus(String id, String newStatus) {
    final index = allEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      final e = allEvents[index];
      allEvents[index] = Event(
        id: e.id, title: e.title, date: e.date, time: e.time,
        location: e.location, category: e.category, organizer: e.organizer,
        description: e.description, status: newStatus, hostStudentId: e.hostStudentId,
      );
      _addNotification('Event "${e.title}" status changed to $newStatus.', 'campaign');
      notifyListeners();
    }
  }

  void sendEventNotice(String id, String message) {
    final event = allEvents.firstWhere((e) => e.id == id, orElse: () =>
      const Event(id:'',title:'',date:'',time:'',location:'',category:'',organizer:'',description:'',status:''));
    if (event.title.isNotEmpty) {
      _addNotification('Notice for event "${event.title}": $message', 'personal');
      notifyListeners();
    }
  }

  // ── NOTIFICATIONS ───────────────────────────────────────────────
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

  void addNotification(String message, String type) {
    _addNotification(message, type);
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

  // ── LOCKERS ──────────────────────────────────────────────────────
  void bookLocker(String lockerId, {int durationMonths = 6}) {
    final lockerIndex = lockers.indexWhere((l) => l.id == lockerId);
    if (lockerIndex == -1) return;

    // Check max 1 locker per student
    if (myBookings.any((b) => b.status == 'Active' || b.status == 'Pending Pickup')) {
      return; // Already has a locker
    }

    final lk = lockers[lockerIndex];
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + durationMonths, now.day);
    final daysLeft = endDate.difference(now).inDays;
    final deposit = 100.0;
    final monthlyRent = 10.0;
    final totalPaid = deposit + monthlyRent; // deposit + first month

    // Generate digital code if digital lock
    final digitalCode = lk.lockType == 'digital'
        ? '${Random().nextInt(9000) + 1000}'
        : null;

    // Update locker status
    lockers[lockerIndex] = Locker(
      id: lk.id, location: lk.location, status: 'Pending Pickup',
      studentId: 'S001',
      startDate: now.toString().split(' ')[0],
      endDate: endDate.toString().split(' ')[0],
      daysLeft: daysLeft,
      lockType: lk.lockType,
      digitalCode: digitalCode,
      monthlyRent: monthlyRent,
      deposit: deposit,
    );

    // Create booking
    final booking = LockerBooking(
      id: 'BK-${DateTime.now().millisecondsSinceEpoch}',
      lockerId: lk.id,
      location: lk.location,
      startDate: now.toString().split(' ')[0],
      endDate: endDate.toString().split(' ')[0],
      status: 'Pending Pickup',
      daysLeft: daysLeft,
      durationMonths: durationMonths,
      monthlyRent: monthlyRent,
      deposit: deposit,
      totalPaid: totalPaid,
    );
    myBookings.add(booking);

    // Add history
    _addLockerHistory(lk.id, 'Booked by student', 'system', 'Student self-booking. Duration: $durationMonths months. Paid: RM${totalPaid.toStringAsFixed(0)}');
    _addNotification('Locker ${lk.id} booked successfully. Duration: $durationMonths months. Total: RM${totalPaid.toStringAsFixed(0)} (RM$deposit deposit + RM$monthlyRent first month).', 'personal');
    notifyListeners();
  }

  void releaseBooking(String bookingId) {
    final index = myBookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) return;
    final booking = myBookings[index];

    // Update locker status back to Available
    final lockerIndex = lockers.indexWhere((l) => l.id == booking.lockerId);
    if (lockerIndex != -1) {
      final lk = lockers[lockerIndex];
      lockers[lockerIndex] = Locker(
        id: lk.id, location: lk.location, status: 'Available',
        lockType: lk.lockType,
      );
      _addLockerHistory(lk.id, 'Released by student', 'system', 'Student released locker early');
    }

    myBookings.removeAt(index);
    _addNotification('Locker ${booking.lockerId} released.', 'personal');
    notifyListeners();
  }

  // ── LOCKER ADMIN ACTIONS ─────────────────────────────────────────
  void updateLockerStatus(String lockerId, String newStatus) {
    final index = lockers.indexWhere((l) => l.id == lockerId);
    if (index == -1) return;
    final lk = lockers[index];

    lockers[index] = Locker(
      id: lk.id, location: lk.location, status: newStatus,
      studentId: newStatus == 'Available' || newStatus == 'Blocked' ? null : lk.studentId,
      startDate: lk.startDate,
      endDate: lk.endDate,
      daysLeft: lk.daysLeft,
      lockType: lk.lockType,
      digitalCode: lk.digitalCode,
      monthlyRent: lk.monthlyRent,
      deposit: lk.deposit,
      depositRefunded: lk.depositRefunded,
    );

    _addLockerHistory(lockerId, 'Status changed to $newStatus', 'ADMIN', 'Admin updated locker status');
    _addNotification('Locker $lockerId status updated to $newStatus.', 'admin');
    notifyListeners();
  }

  void terminateLocker(String lockerId) {
    final index = lockers.indexWhere((l) => l.id == lockerId);
    if (index == -1) return;
    final lk = lockers[index];

    // Remove booking if exists
    myBookings.removeWhere((b) => b.lockerId == lockerId);

    lockers[index] = Locker(
      id: lk.id, location: lk.location, status: 'Available',
      lockType: lk.lockType,
    );

    _addLockerHistory(lockerId, 'Agreement terminated', 'ADMIN', 'Admin terminated locker agreement. Deposit forfeited.');
    if (lk.studentId != null) {
      _addNotification('Your locker $lockerId agreement has been terminated by admin. Deposit forfeited.', 'personal');
    }
    _addNotification('Locker $lockerId terminated.', 'admin');
    notifyListeners();
  }

  void blockLocker(String lockerId, {String? reason}) {
    final index = lockers.indexWhere((l) => l.id == lockerId);
    if (index == -1) return;
    final lk = lockers[index];

    // Remove booking if exists
    myBookings.removeWhere((b) => b.lockerId == lockerId);

    lockers[index] = Locker(
      id: lk.id, location: lk.location, status: 'Blocked',
      lockType: lk.lockType,
    );

    _addLockerHistory(lockerId, 'Locker blocked', 'ADMIN', reason ?? 'Admin blocked locker');
    _addNotification('Locker $lockerId has been blocked.', 'admin');
    notifyListeners();
  }

  void releaseLockerAdmin(String lockerId) {
    final index = lockers.indexWhere((l) => l.id == lockerId);
    if (index == -1) return;
    final lk = lockers[index];

    // Remove booking if exists
    myBookings.removeWhere((b) => b.lockerId == lockerId);

    lockers[index] = Locker(
      id: lk.id, location: lk.location, status: 'Available',
      lockType: lk.lockType,
    );

    _addLockerHistory(lockerId, 'Locker released', 'ADMIN', 'Admin released locker. Made available.');
    _addNotification('Locker $lockerId has been released and is now available.', 'admin');
    notifyListeners();
  }

  void sendLockerNotice(String lockerId, String message) {
    final lk = lockers.firstWhere((l) => l.id == lockerId, orElse: () =>
      const Locker(id: '', location: '', status: ''));
    if (lk.studentId != null) {
      _addNotification('Notice for locker $lockerId: $message', 'personal');
      _addLockerHistory(lockerId, 'Notice sent to student', 'ADMIN', message);
      notifyListeners();
    }
  }

  void _addLockerHistory(String lockerId, String action, String staffId, String? reason) {
    final list = lockerHistory[lockerId] ?? [];
    list.add(LockerHistory(
      action: action,
      staffId: staffId,
      timestamp: DateTime.now().toString().split('.')[0],
      reason: reason,
    ));
    lockerHistory[lockerId] = list;
  }

  // ── STUDENT REGISTRATION ─────────────────────────────────────────
  void submitRegistration(StudentRegistration reg) {
    pendingRegistrations.add(reg);
    _addNotification('New student registration: ${reg.name} (${reg.studentId})', 'admin');
    notifyListeners();
  }

  void approveRegistration(String regId) {
    final index = pendingRegistrations.indexWhere((r) => r.id == regId);
    if (index != -1) {
      final reg = pendingRegistrations[index];
      pendingRegistrations[index] = StudentRegistration(
        id: reg.id, studentId: reg.studentId, name: reg.name,
        email: reg.email, faculty: reg.faculty, password: reg.password,
        status: 'Approved', submittedDate: reg.submittedDate,
      );
      _addNotification('Registration approved for ${reg.name} (${reg.studentId}).', 'admin');
      notifyListeners();
    }
  }

  void rejectRegistration(String regId) {
    final index = pendingRegistrations.indexWhere((r) => r.id == regId);
    if (index != -1) {
      final reg = pendingRegistrations[index];
      pendingRegistrations[index] = StudentRegistration(
        id: reg.id, studentId: reg.studentId, name: reg.name,
        email: reg.email, faculty: reg.faculty, password: reg.password,
        status: 'Rejected', submittedDate: reg.submittedDate,
      );
      _addNotification('Registration rejected for ${reg.name} (${reg.studentId}).', 'admin');
      notifyListeners();
    }
  }

  int get unreadNotificationCount => notifications.where((n) => !n.read).length;
}
