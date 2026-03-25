import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../services/data_service.dart';

void _toast(BuildContext ctx, String msg) => ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
  behavior: SnackBarBehavior.floating, backgroundColor: AppTheme.textPrimary,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), duration: const Duration(seconds: 2)));

AppBar _appBar(String t, BuildContext ctx) => AppBar(
  title: Text(t), backgroundColor: Colors.transparent,
  flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppTheme.headerGradient)),
  leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), onPressed: () => ctx.pop()));

// ── Screen 28: Locker Hub ────────────────────────────────────────
class LockerHubScreen extends StatelessWidget {
  const LockerHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final booking = dataService.myBookings.isNotEmpty ? dataService.myBookings.first : null;
        return Scaffold(
          body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (booking != null) ...[
              const SectionLabel('Active Booking'),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppTheme.red.withOpacity(0.3), blurRadius: 18, offset: const Offset(0,5))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.lock_rounded, color: Colors.white, size: 24), const SizedBox(width: 10), Text(booking.lockerId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))]),
                  const SizedBox(height: 6),
                  Text(booking.location, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _StatW('Start', fmtDate(booking.startDate)),
                    _StatW('End', fmtDate(booking.endDate)),
                    CountdownBadge(booking.daysLeft),
                  ]),
                ])).animate().fadeIn(delay: 50.ms).slideY(begin: 0.15),
              const SizedBox(height: 6),
              OutlineBtn(label: 'Manage My Locker', onPressed: () => context.push('/lockers/my-locker')),
            ] else ...[
              const NoticeBox(message: 'You don\'t have an active locker. You can browse and book one below.'),
            ],
            const SectionLabel('Services'),
            HubButton(icon: Icons.grid_view_rounded, label: 'Browse Available Lockers', subtitle: '${dataService.lockers.where((l) => l.status == "Available").length} available now', isPrimary: booking == null, onTap: () => context.push('/lockers/browse')).animate().fadeIn(delay:100.ms),
            HubButton(icon: Icons.manage_accounts_rounded, label: 'My Locker', subtitle: booking != null ? 'Booking ${booking.id}' : 'No active booking', onTap: () => context.push('/lockers/my-locker')).animate().fadeIn(delay:150.ms),
          ]))),
        );
      },
    );
  }
}

// ── Screen 29: Browse / Available Lockers ────────────────────────
class BrowseLockersScreen extends StatelessWidget {
  const BrowseLockersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final blocks = {'Block A, Level 1': 'LK-A', 'Block B, Level 2': 'LK-B', 'Block C, Level 1': 'LK-C'};
        return Scaffold(
          appBar: _appBar('Available Lockers', context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NoticeBox(message: 'Locker rentals are for 6 months. Key collection at Facilities Office, Block A Level 1.'),
            ...blocks.entries.map((entry) {
              final lks = dataService.lockers.where((l) => l.location == entry.key).toList();
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SectionLabel(entry.key),
                GridView.count(crossAxisCount: 4, childAspectRatio: 1.1, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 8, crossAxisSpacing: 8,
                  children: lks.map((lk) {
                    Color c; Color tc;
                    switch (lk.status) {
                      case 'Available': c = AppTheme.red.withOpacity(0.12); tc = AppTheme.redDark; break;
                      case 'Active':   c = AppTheme.redLight.withOpacity(0.12); tc = AppTheme.red;     break;
                      case 'Overdue':  c = AppTheme.danger.withOpacity(0.12); tc = AppTheme.danger;  break;
                      case 'Blocked':  c = Colors.grey.withOpacity(0.12);    tc = Colors.grey;       break;
                      default:         c = AppTheme.gold.withOpacity(0.2);   tc = AppTheme.goldDark;
                    }
                    return GestureDetector(
                      onTap: lk.status == 'Available' ? () => context.push('/lockers/detail/${lk.id}') : null,
                      child: Container(decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10), border: Border.all(color: tc.withOpacity(0.3))),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.lock_rounded, color: tc, size: 20),
                          const SizedBox(height: 4),
                          Text(lk.id.split('-').last, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: tc)),
                        ])));
                  }).toList()),
                const SizedBox(height: 8),
                Row(children: [
                  _Key(AppTheme.red.withOpacity(0.15), AppTheme.redDark, 'Available'),
                  const SizedBox(width: 14),
                  _Key(AppTheme.redLight.withOpacity(0.15), AppTheme.red, 'Taken'),
                  const SizedBox(width: 14),
                  _Key(AppTheme.danger.withOpacity(0.15), AppTheme.danger, 'Overdue'),
                ]),
              ]);
            }),
          ])),
        );
      },
    );
  }
}

// ── Screen 30: Locker Booking ────────────────────────────────────
class LockerBookingScreen extends StatelessWidget {
  final String id;
  const LockerBookingScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final lk = dataService.lockers.firstWhere((x) => x.id == id, orElse: () => Locker(
          id: '', location: '', status: '', studentId: null, endDate: '', daysLeft: null
        ));
        return Scaffold(
          appBar: _appBar('Book Locker', context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(lk.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text(lk.location, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                  const SizedBox(height: 6),
                  StatusBadge(lk.status),
                ])),
              ]),
              const Divider(height: 20),
              const InfoRow(label: 'Duration', value: 'Semester (6 months)'),
              const InfoRow(label: 'Start Date', value: 'Immediate'),
              const InfoRow(label: 'End Date', value: '30 Jun 2026'),
              const InfoRow(label: 'Fee', value: 'Included in student dues'),
            ]))),
            NoticeBox(message: 'By booking, you agree to the Locker Rental Policy. Key collection at Facilities Office within 3 working days.', borderColor: AppTheme.goldDark, bgColor: AppTheme.gold.withOpacity(0.12), textColor: const Color(0xFF7A5B00), icon: Icons.info_outline_rounded),
            GradientButton(label: 'Confirm Booking', onPressed: () { _toast(context, 'Booking confirmed! Collect key at Block A, Level 1.'); context.go('/lockers'); }),
            const SizedBox(height: 10),
            OutlineBtn(label: 'Cancel', onPressed: () => context.pop()),
          ])),
        );
      },
    );
  }
}

// ── Screen 31: My Locker ─────────────────────────────────────────
class MyLockerScreen extends StatelessWidget {
  const MyLockerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final booking = dataService.myBookings.isNotEmpty ? dataService.myBookings.first : null;
        if (booking == null) {
          return Scaffold(
            appBar: _appBar('My Locker', context),
            body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const EmptyState(title: 'No Active Booking', subtitle: 'You don\'t have a locker. Browse available lockers to book one.', icon: Icons.lock_open_rounded),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: GradientButton(label: 'Browse Lockers', onPressed: () => context.push('/lockers/browse'))),
            ]),
          );
        }
        return Scaffold(
          appBar: _appBar('My Locker', context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppTheme.red.withOpacity(0.3), blurRadius: 20, offset: const Offset(0,6))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [const Icon(Icons.lock_rounded, color: Colors.white, size: 28), const SizedBox(width: 12), Text(booking.lockerId, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white))]),
                const SizedBox(height: 6),
                Text(booking.location, style: TextStyle(color: Colors.white.withOpacity(0.85))),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _StatW('Start', fmtDate(booking.startDate)),
                  _StatW('End', fmtDate(booking.endDate)),
                  _StatW('Status', booking.status),
                  CountdownBadge(booking.daysLeft),
                ]),
              ])).animate().fadeIn(delay: 50.ms).slideY(begin: 0.15),
            const SectionLabel('Quick Actions'),
            HubButton(icon: Icons.swap_horiz_rounded, label: 'Request Extension', subtitle: 'Extend rental period', onTap: () => _toast(context, 'Extension request sent.')),
            HubButton(icon: Icons.report_problem_rounded, label: 'Report Locker Issue', subtitle: 'Damage, malfunction, etc.', onTap: () => context.push('/issues/report')),
            HubButton(icon: Icons.cancel_rounded, label: 'Release Locker', subtitle: 'End your rental early', isAmber: false, iconColor: AppTheme.danger, onTap: () => _showConfirm(context, booking.id)),
          ])),
        );
      },
    );
  }

  void _showConfirm(BuildContext context, String id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Release Locker?'),
      content: Text('Are you sure you want to release booking $id? This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () { Navigator.pop(context); _toast(context, 'Locker released successfully.'); }, child: const Text('Release', style: TextStyle(color: AppTheme.danger))),
      ],
    ));
  }
}

// ── Screen 33: Admin Locker Dashboard ───────────────────────────
class AdminLockerDashboardScreen extends StatelessWidget {
  const AdminLockerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final lks = dataService.lockers;
        final avail   = lks.where((l) => l.status == 'Available').length;
        final active  = lks.where((l) => l.status == 'Active').length;
        final overdue = lks.where((l) => l.status == 'Overdue').length;
        return Scaffold(
          body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const AdminBar(), const SizedBox(height: 10),
            Row(children: [
              Expanded(child: StatCard(value: '${lks.length}', label: 'Total')),
              const SizedBox(width: 8),
              Expanded(child: StatCard(value: '$avail', label: 'Available', valueColor: AppTheme.redDark, bgColor: AppTheme.red.withOpacity(0.07))),
              const SizedBox(width: 8),
              Expanded(child: StatCard(value: '$active', label: 'Active', valueColor: AppTheme.red, bgColor: AppTheme.red.withOpacity(0.06))),
              const SizedBox(width: 8),
              Expanded(child: StatCard(value: '$overdue', label: 'Overdue', valueColor: const Color(0xFFB03030), bgColor: const Color(0x08D65E5E))),
            ]).animate().fadeIn(delay:50.ms),
            const SectionLabel('Actions'),
            HubButton(icon: Icons.grid_view_rounded, label: 'Locker Grid', subtitle: 'View all locker statuses', onTap: () => context.push('/admin/lockers/list')),
            HubButton(icon: Icons.person_search_rounded, label: 'Student Lookup', subtitle: 'Find by student ID', isAmber: true, onTap: () => _toast(context, 'Student lookup feature coming soon')),
            if (overdue > 0) NoticeBox(message: '$overdue locker(s) are overdue. Action required.', borderColor: AppTheme.danger, bgColor: AppTheme.danger.withOpacity(0.06), textColor: const Color(0xFF8B2020), icon: Icons.warning_rounded),
          ]))),
        );
      },
    );
  }
}

// ── Screen 34: Admin Lockers List ────────────────────────────────
class AdminLockersListScreen extends StatelessWidget {
  const AdminLockersListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final data = dataService.lockers;
        return Scaffold(
          appBar: _appBar('All Lockers', context),
          body: Column(children: [
            const Padding(padding: EdgeInsets.fromLTRB(16,8,16,0), child: AdminBar()),
            Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
              final lk = data[i];
              return CardRow(
                title: lk.id, subtitle: lk.location, status: lk.status,
                extra: lk.studentId != null ? 'Student: ${lk.studentId}' : null,
                trailing: lk.daysLeft != null ? CountdownBadge(lk.daysLeft!) : null,
                onTap: () => context.push('/admin/lockers/detail/${lk.id}'),
              ).animate().fadeIn(delay: (i*50).ms).slideY(begin:0.1);
            })),
          ]),
        );
      },
    );
  }
}

// ── Screen 35: Admin Locker Detail ───────────────────────────────
class AdminLockerDetailScreen extends StatelessWidget {
  final String id;
  const AdminLockerDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final lk   = dataService.lockers.firstWhere((x) => x.id == id, orElse: () => Locker(
          id: '', location: '', status: '', studentId: null, endDate: '', daysLeft: null
        ));
        final hist = MockData.lockerHistory[lk.id] ?? [];
        return Scaffold(
          appBar: _appBar(lk.id, context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const AdminBar(), const SizedBox(height: 8),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              Row(children: [Expanded(child: Text(lk.id, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))), StatusBadge(lk.status)]),
              const Divider(height: 18),
              InfoRow(label: 'Location', value: lk.location),
              if (lk.studentId != null) InfoRow(label: 'Student ID', value: lk.studentId!),
              if (lk.endDate != null && lk.endDate!.isNotEmpty)   InfoRow(label: 'End Date', value: fmtDate(lk.endDate!)),
              if (lk.daysLeft != null)  Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(top: 8), child: CountdownBadge(lk.daysLeft!))),
            ]))),
            const SectionLabel('Admin Actions'),
            DropdownButtonFormField<String>(initialValue: lk.status, decoration: const InputDecoration(labelText: 'Update Status'), onChanged: (_){},
              items: ['Available','Active','Pending Pickup','Overdue','Blocked'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList()),
            const SizedBox(height: 12),
            GradientButton(label: 'Save Changes', onPressed: () => _toast(context, 'Status updated')),
            if (lk.status == 'Overdue') ...[
              const SizedBox(height: 10),
              OutlineBtn(label: 'Send Overdue Reminder', color: AppTheme.danger, onPressed: () => _toast(context, 'Reminder sent to student')),
            ],
            if (hist.isNotEmpty) ...[
              const SectionLabel('History'),
              ...hist.map((h) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.creamLight, borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Text('${h.timestamp} · ${h.staffId}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                if (h.reason != null) Text(h.reason!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ])))),
            ],
          ])),
        );
      },
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────
class _StatW extends StatelessWidget {
  final String label, value;
  const _StatW(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w600)),
    const SizedBox(height: 2),
    Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
  ]);
}

class _Key extends StatelessWidget {
  final Color bg, fg; final String label;
  const _Key(this.bg, this.fg, this.label);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 12, height: 12, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(3), border: Border.all(color: fg.withOpacity(0.4)))),
    const SizedBox(width: 5),
    Text(label, style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w600)),
  ]);
}
