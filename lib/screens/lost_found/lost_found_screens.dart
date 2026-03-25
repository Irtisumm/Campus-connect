import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../widgets/common.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../services/data_service.dart';

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppTheme.textPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    duration: const Duration(seconds: 2),
  ));
}

AppBar _gradientAppBar(String title, BuildContext context, {List<Widget>? actions}) => AppBar(
  title: Text(title),
  flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppTheme.headerGradient)),
  backgroundColor: Colors.transparent,
  leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), onPressed: () => context.pop()),
  actions: actions,
);

// ── Screen 1: Hub ────────────────────────────────────────────────
class LostFoundHubScreen extends StatelessWidget {
  const LostFoundHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Scaffold(
          body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NoticeBox(message: 'All item details are kept private. Only university management can view full details.', icon: Icons.lock_outline_rounded),
            const SectionLabel('Report an Item'),
            HubButton(icon: Icons.search_rounded, label: 'Report Lost Item', subtitle: "I've lost something on campus", isPrimary: true, onTap: () => context.push('/lost-found/report-lost')).animate().fadeIn(delay: 50.ms).slideY(begin: 0.2),
            HubButton(icon: Icons.add_box_rounded, label: 'Report Found Item', subtitle: 'I found something on campus', isAmber: true, onTap: () => context.push('/lost-found/report-found')).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
            const SectionLabel('My Reports'),
            HubButton(icon: Icons.description_rounded, label: 'My Lost Reports', subtitle: '${dataService.myLostReports.length} reports submitted', onTap: () => context.push('/lost-found/my-lost')).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
            HubButton(icon: Icons.upload_file_rounded, label: 'My Found Reports', subtitle: '${dataService.myFoundReports.length} reports submitted', onTap: () => context.push('/lost-found/my-found')).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          ]))),
        );
      },
    );
  }
}

// ── Screen 2: Report Lost ────────────────────────────────────────
class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});
  @override State<ReportLostScreen> createState() => _ReportLostState();
}
class _ReportLostState extends State<ReportLostScreen> {
  final _key = GlobalKey<FormState>();
  String? _cat, _loc;
  final _titleC = TextEditingController();
  final _descC  = TextEditingController();
  bool _done = false;

  static const _cats = ['Phone','Wallet','ID Card','Keys','Bag','Laptop','Books','Other'];
  static const _locs = ['Block A','Block B','Block C','Library','Cafeteria','Sports Complex','Main Entrance','Other'];

  @override
  Widget build(BuildContext context) {
    if (_done) return _SuccessView(title: 'Report Submitted!', msg: "Your item has been reported. Admin will review it. We'll notify you if a match is found.", onHome: () => context.go('/lost-found'), onSub: () => context.push('/lost-found/my-lost'), subLabel: 'View My Reports');
    return Scaffold(
      appBar: _gradientAppBar('Report Lost Item', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: _key, child: Column(children: [
        const NoticeBox(message: 'Max 5 active reports. Provide a detailed description to improve match accuracy.'),
        _Drop(label: 'Category', value: _cat, items: _cats, onChanged: (v) => setState(() => _cat = v)),
        _Field(label: 'Item Title', hint: 'e.g. Blue Samsung Galaxy S23', ctrl: _titleC, validator: (v) => v!.isEmpty ? 'Required' : null),
        _Area(label: 'Description', hint: 'Color, brand, markings…', ctrl: _descC),
        _Drop(label: 'Where Lost', value: _loc, items: _locs, onChanged: (v) => setState(() => _loc = v)),
        _PhotoBox(),
        const SizedBox(height: 16),
        GradientButton(label: 'Submit Report', onPressed: () {
          if (_key.currentState!.validate() && _cat != null && _loc != null) {
            final dataService = context.read<DataService>();
            final newReport = LostReport(
              id: 'LR-${DateTime.now().millisecondsSinceEpoch}',
              title: _titleC.text,
              category: _cat!,
              whereLost: _loc!,
              whenLost: DateTime.now().toString().split(' ')[0],
              status: 'Active',
              description: _descC.text,
            );
            dataService.addLostReport(newReport);
            setState(() => _done = true);
          } else {
            _toast(context, 'Please fill all fields');
          }
        }),
        const SizedBox(height: 10),
        OutlineBtn(label: 'Cancel', onPressed: () => context.pop()),
      ]))),
    );
  }
}

// ── Screen 3: Report Found ───────────────────────────────────────
class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});
  @override State<ReportFoundScreen> createState() => _ReportFoundState();
}
class _ReportFoundState extends State<ReportFoundScreen> {
  String? _cat, _loc;
  final _descC = TextEditingController();
  bool _done = false;

  static const _cats = ['Phone','Wallet','ID Card','Keys','Bag','Laptop','Books','Other'];
  static const _locs = ['Block A','Block B','Block C','Library','Cafeteria','Sports Complex','Main Entrance','Other'];

  @override
  Widget build(BuildContext context) {
    if (_done) return _SuccessView(title: 'Found Item Reported!', msg: 'Thank you! Please hand the item to the Lost & Found Office.', onHome: () => context.go('/lost-found'));
    return Scaffold(
      appBar: _gradientAppBar('Report Found Item', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        NoticeBox(message: 'Please hand the item to Lost & Found Office (Block A, Level 1) after submitting.', borderColor: AppTheme.red, bgColor: AppTheme.red.withOpacity(0.08), textColor: const Color(0xFF8B1428)),
        _Drop(label: 'Category', value: _cat, items: _cats, onChanged: (v) => setState(() => _cat = v)),
        _Area(label: 'Description', hint: 'Describe what you found', ctrl: _descC),
        _Drop(label: 'Where Found', value: _loc, items: _locs, onChanged: (v) => setState(() => _loc = v)),
        _PhotoBox(),
        const SizedBox(height: 16),
        GradientButton(label: 'Submit Report', onPressed: () => setState(() => _done = true)),
        const SizedBox(height: 10),
        OutlineBtn(label: 'Cancel', onPressed: () => context.pop()),
      ])),
    );
  }
}

// ── Screen 4: My Lost Reports ────────────────────────────────────
class MyLostReportsScreen extends StatelessWidget {
  const MyLostReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final data = dataService.myLostReports;
        return Scaffold(
          appBar: _gradientAppBar('My Lost Reports', context, actions: [
            TextButton.icon(onPressed: () => context.push('/lost-found/report-lost'), icon: const Icon(Icons.add, color: Colors.white, size: 16), label: const Text('Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          ]),
          body: data.isEmpty
              ? const EmptyState(title: 'No Lost Reports', icon: Icons.search_off_rounded)
              : ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
                  final r = data[i];
                  return CardRow(title: r.title, subtitle: '${r.category} · ${r.whereLost}', extra: relativeTime(r.whenLost), status: r.status, onTap: () => context.push('/lost-found/lost/${r.id}')).animate().fadeIn(delay: (i*60).ms).slideY(begin: 0.15);
                }),
        );
      },
    );
  }
}

// ── Screen 5: My Found Reports ───────────────────────────────────
class MyFoundReportsScreen extends StatelessWidget {
  const MyFoundReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final data = dataService.myFoundReports;
        return Scaffold(
          appBar: _gradientAppBar('My Found Reports', context),
          body: data.isEmpty
              ? const EmptyState(title: 'No Found Reports', icon: Icons.upload_file_rounded)
              : ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
                  final r = data[i];
                  return CardRow(title: r.description, subtitle: '${r.category} · ${r.whereFound}', extra: relativeTime(r.whenFound), status: r.status, onTap: () => context.push('/lost-found/found/${r.id}')).animate().fadeIn(delay: (i*60).ms).slideY(begin: 0.15);
                }),
        );
      },
    );
  }
}

// ── Screen 6: Lost Detail (Student) ─────────────────────────────
class LostDetailScreen extends StatelessWidget {
  final String id;
  const LostDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final r = MockData.myLostReports.firstWhere((x) => x.id == id, orElse: () => MockData.myLostReports.first);
    return Scaffold(
      appBar: _gradientAppBar(r.id, context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (r.matchStatus != null) NoticeBox(message: r.matchStatus!, borderColor: AppTheme.red, icon: Icons.link_rounded),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(r.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))), StatusBadge(r.status)]),
          const Divider(height: 20),
          InfoRow(label: 'Category', value: r.category),
          InfoRow(label: 'Where Lost', value: r.whereLost),
          InfoRow(label: 'When Lost', value: fmtDate(r.whenLost)),
          const Divider(height: 12),
          const Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          Text(r.description, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.65)),
        ]))),
        const SizedBox(height: 10),
        if (r.status == 'Active') OutlineBtn(label: 'Close Report', color: AppTheme.danger, onPressed: () => _toast(context, 'Report closed')),
      ])),
    );
  }
}

// ── Screen 7: Found Detail (Student) ────────────────────────────
class FoundDetailScreen extends StatelessWidget {
  final String id;
  const FoundDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final r = MockData.myFoundReports.firstWhere((x) => x.id == id, orElse: () => MockData.myFoundReports.first);
    return Scaffold(
      appBar: _gradientAppBar(r.id, context),
      body: Padding(padding: const EdgeInsets.all(16), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(r.description, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))), StatusBadge(r.status)]),
        const Divider(height: 20),
        InfoRow(label: 'Category', value: r.category),
        InfoRow(label: 'Where Found', value: r.whereFound),
        InfoRow(label: 'When Found', value: fmtDate(r.whenFound)),
      ])))),
    );
  }
}

// ── Screen 8: Notifications ──────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const ns = MockData.notifications;
    return Scaffold(
      appBar: _gradientAppBar('Notifications', context),
      body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: ns.length, itemBuilder: (ctx, i) {
        final n = ns[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: n.read ? AppTheme.bgCard : AppTheme.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: n.read ? AppTheme.red.withOpacity(0.1) : AppTheme.red.withOpacity(0.25)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(backgroundColor: n.type == 'personal' ? AppTheme.red.withOpacity(0.12) : AppTheme.gold.withOpacity(0.2),
                child: Icon(n.type == 'personal' ? Icons.person_rounded : Icons.campaign_rounded, color: n.type == 'personal' ? AppTheme.red : AppTheme.goldDark, size: 20)),
            title: Text(n.text, style: TextStyle(fontSize: 13, fontWeight: n.read ? FontWeight.w500 : FontWeight.w700, color: AppTheme.textPrimary)),
            subtitle: Text(n.time, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            trailing: n.read ? null : Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.red, shape: BoxShape.circle)),
          ),
        ).animate().fadeIn(delay: (i*55).ms).slideX(begin: 0.1);
      }),
    );
  }
}

// ── Screen 9: Admin L&F Dashboard ───────────────────────────────
class AdminLFDashboardScreen extends StatelessWidget {
  const AdminLFDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final active = MockData.allLostReports.where((r) => r.status == 'Active').length;
    final pending = MockData.matches.where((m) => m.status == 'Pending').length;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AdminBar(), const SizedBox(height: 10),
        Row(children: [
          Expanded(child: StatCard(value: '$active', label: 'Active Lost')),
          const SizedBox(width: 10),
          Expanded(child: StatCard(value: '${MockData.myFoundReports.length}', label: 'In Inventory', valueColor: AppTheme.redDark, bgColor: AppTheme.red.withOpacity(0.07))),
          const SizedBox(width: 10),
          Expanded(child: StatCard(value: '$pending', label: 'Pending Matches', valueColor: const Color(0xFFB03030), bgColor: const Color(0x08D65E5E))),
        ]).animate().fadeIn(delay: 50.ms),
        const SectionLabel('Quick Actions'),
        HubButton(icon: Icons.list_alt_rounded, label: 'View Lost Reports', subtitle: '${MockData.allLostReports.length} total', onTap: () => context.push('/admin/lost-found/lost-list')).animate().fadeIn(delay:100.ms),
        HubButton(icon: Icons.inventory_rounded, label: 'Found / Inventory', subtitle: '${MockData.myFoundReports.length} items', isAmber: true, onTap: () => context.push('/admin/lost-found/found-list')).animate().fadeIn(delay:150.ms),
        HubButton(icon: Icons.compare_arrows_rounded, label: 'Review Matches', subtitle: '$pending pending', onTap: () => context.push('/admin/lost-found/match-list')).animate().fadeIn(delay:200.ms),
      ]))),
    );
  }
}

// ── Screen 10: Admin Lost List ───────────────────────────────────
class AdminLostListScreen extends StatelessWidget {
  const AdminLostListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const data = MockData.allLostReports;
    return Scaffold(
      appBar: _gradientAppBar('All Lost Reports', context),
      body: Column(children: [
        const Padding(padding: EdgeInsets.fromLTRB(16,8,16,0), child: AdminBar()),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
          final r = data[i];
          return CardRow(
            title: r.title, subtitle: '${r.studentId} · ${r.category}', extra: fmtDate(r.createdDate), status: r.status,
            trailing: r.aiScore != null ? Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(999)),
                child: Text('AI ${r.aiScore}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white))) : null,
            onTap: () => context.push('/admin/lost-found/lost/${r.id}'),
          ).animate().fadeIn(delay: (i*55).ms).slideY(begin: 0.12);
        })),
      ]),
    );
  }
}

// ── Screen 11: Admin Found List ──────────────────────────────────
class AdminFoundListScreen extends StatelessWidget {
  const AdminFoundListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const data = MockData.myFoundReports;
    return Scaffold(
      appBar: _gradientAppBar('Found / Inventory', context),
      body: Column(children: [
        const Padding(padding: EdgeInsets.fromLTRB(16,8,16,0), child: AdminBar()),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
          final r = data[i];
          return CardRow(title: r.description, subtitle: '${r.category} · ${r.whereFound}', extra: fmtDate(r.whenFound), status: r.status, onTap: () => context.push('/admin/lost-found/found/${r.id}')).animate().fadeIn(delay: (i*55).ms);
        })),
      ]),
    );
  }
}

// ── Screen 12: Admin Lost Detail ─────────────────────────────────
class AdminLostDetailScreen extends StatelessWidget {
  final String id;
  const AdminLostDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final r = MockData.allLostReports.firstWhere((x) => x.id == id, orElse: () => MockData.allLostReports.first);
    final matches = MockData.matches.where((m) => m.lostId == r.id).toList();
    return Scaffold(
      appBar: _gradientAppBar(r.id, context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AdminBar(), const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [Expanded(child: Text(r.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))), StatusBadge(r.status)]),
          const Divider(height: 18),
          InfoRow(label: 'Student ID', value: r.studentId),
          InfoRow(label: 'Category', value: r.category),
          InfoRow(label: 'Where Lost', value: r.whereLost),
          InfoRow(label: 'Submitted', value: fmtDate(r.createdDate)),
        ]))),
        if (r.aiScore != null) ...[
          const SectionLabel('AI Match Score'),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.red.withOpacity(0.08), AppTheme.redLight.withOpacity(0.06)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.red.withOpacity(0.2))),
              child: Row(children: [const Icon(Icons.psychology_rounded, color: AppTheme.red, size: 28), const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('AI Confidence', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.red)),
                  Text('${r.aiScore}% match with ${r.matchedFoundId ?? "found item"}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                ])])),
        ],
        if (matches.isNotEmpty) ...[
          const SectionLabel('Potential Matches'),
          ...matches.map((m) => Card(child: ListTile(title: Text('Found: ${m.foundId}', style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(m.notes), trailing: StatusBadge(m.status), onTap: () => context.push('/admin/lost-found/match/${m.id}')))),
        ],
        const SizedBox(height: 10),
        GradientButton(label: 'Mark as Resolved', onPressed: () => _toast(context, 'Status updated')),
      ])),
    );
  }
}

// ── Screen 13: Admin Found Detail ───────────────────────────────
class AdminFoundDetailScreen extends StatelessWidget {
  final String id;
  const AdminFoundDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final r = MockData.myFoundReports.firstWhere((x) => x.id == id, orElse: () => MockData.myFoundReports.first);
    return Scaffold(
      appBar: _gradientAppBar(r.id, context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        const AdminBar(), const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [Expanded(child: Text(r.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))), StatusBadge(r.status)]),
          const Divider(height: 18),
          InfoRow(label: 'Category', value: r.category),
          InfoRow(label: 'Where Found', value: r.whereFound),
          InfoRow(label: 'When Found', value: fmtDate(r.whenFound)),
        ]))),
        const SizedBox(height: 10),
        GradientButton(label: 'Mark as Resolved', onPressed: () => _toast(context, 'Marked resolved')),
        const SizedBox(height: 10),
        OutlineBtn(label: 'Archive', onPressed: () => _toast(context, 'Archived')),
      ])),
    );
  }
}

// ── Screen 14: Match Review ──────────────────────────────────────
class AdminMatchListScreen extends StatelessWidget {
  const AdminMatchListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const data = MockData.matches;
    return Scaffold(
      appBar: _gradientAppBar('Review Matches', context),
      body: Column(children: [
        const Padding(padding: EdgeInsets.fromLTRB(16,8,16,0), child: AdminBar()),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, itemBuilder: (ctx, i) {
          final m = data[i];
          return CardRow(title: '${m.lostId} ↔ ${m.foundId}', subtitle: m.notes, status: m.status,
            trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(999)),
                child: Text('${m.score}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white))),
            onTap: () => context.push('/admin/lost-found/match/${m.id}'),
          ).animate().fadeIn(delay: (i*60).ms);
        })),
      ]),
    );
  }
}

class AdminMatchDetailScreen extends StatelessWidget {
  final String id;
  const AdminMatchDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final m = MockData.matches.firstWhere((x) => x.id == id, orElse: () => MockData.matches.first);
    return Scaffold(
      appBar: _gradientAppBar('Match ${m.id}', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AdminBar(), const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                child: Text('${m.score}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))),
            const SizedBox(width: 14),
            const Expanded(child: Text('AI Confidence Score', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
            StatusBadge(m.status),
          ]),
          const Divider(height: 18),
          InfoRow(label: 'Lost Report', value: m.lostId),
          InfoRow(label: 'Found Report', value: m.foundId),
          const SizedBox(height: 10),
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.creamLight, borderRadius: BorderRadius.circular(10)),
              child: Text(m.notes, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.55))),
        ]))),
        const SizedBox(height: 10),
        GradientButton(label: '✓ Confirm Match – Notify Student', onPressed: () => _toast(context, 'Match confirmed. Student notified.')),
        const SizedBox(height: 10),
        OutlineBtn(label: 'Reject Match', color: AppTheme.danger, onPressed: () => _toast(context, 'Match rejected')),
      ])),
    );
  }
}

// ── Shared Private Widgets ────────────────────────────────────────
class _Drop extends StatelessWidget {
  final String label; final String? value; final List<String> items; final void Function(String?) onChanged;
  const _Drop({required this.label, required this.value, required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(initialValue: value, decoration: InputDecoration(labelText: label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged));
}
class _Field extends StatelessWidget {
  final String label, hint; final TextEditingController ctrl; final String? Function(String?)? validator;
  const _Field({required this.label, required this.hint, required this.ctrl, this.validator});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(controller: ctrl, validator: validator, decoration: InputDecoration(labelText: label, hintText: hint)));
}
class _Area extends StatelessWidget {
  final String label, hint; final TextEditingController ctrl;
  const _Area({required this.label, required this.hint, required this.ctrl});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(controller: ctrl, maxLines: 4, decoration: InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: true)));
}
class _PhotoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _toast(context, 'Photo upload available in installed APK'),
    child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(color: AppTheme.red.withOpacity(0.04), border: Border.all(color: AppTheme.red.withOpacity(0.25), width: 1.5), borderRadius: BorderRadius.circular(14)),
      child: const Column(children: [Icon(Icons.add_photo_alternate_rounded, size: 36, color: AppTheme.textMuted), SizedBox(height: 8),
        Text('Tap to add photo', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        Text('Optional', style: TextStyle(fontSize: 11, color: AppTheme.textMuted))])));
}

class _SuccessView extends StatelessWidget {
  final String title, msg; final VoidCallback onHome; final VoidCallback? onSub; final String? subLabel;
  const _SuccessView({required this.title, required this.msg, required this.onHome, this.onSub, this.subLabel});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 80, height: 80, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.red.withOpacity(0.2), AppTheme.redLight.withOpacity(0.15)]), shape: BoxShape.circle, border: Border.all(color: AppTheme.red.withOpacity(0.3))),
        child: const Icon(Icons.check_rounded, color: AppTheme.red, size: 40)).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
    const SizedBox(height: 24),
    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)).animate().fadeIn(delay: 200.ms),
    const SizedBox(height: 12),
    Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.65)).animate().fadeIn(delay: 300.ms),
    const SizedBox(height: 28),
    GradientButton(label: 'Back to Hub', onPressed: onHome),
    if (onSub != null) ...[const SizedBox(height: 10), OutlineBtn(label: subLabel!, onPressed: onSub)],
  ]))));
}
