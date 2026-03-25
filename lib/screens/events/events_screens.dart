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

const _catColors = {
  'Academic': [Color(0x1AC41E3A), Color(0xFFC41E3A)],
  'Sport':    [Color(0x1AE8475F), Color(0xFFE8475F)],
  'Club':     [Color(0x1AF8D49B), Color(0xFFE8B96A)],
  'General':  [Color(0x1AC41E3A), Color(0xFFC41E3A)],
};

// ── Screen 22: Events Hub ────────────────────────────────────────
class EventsHubScreen extends StatelessWidget {
  const EventsHubScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final events = dataService.allEvents;
        return Scaffold(
          body: SafeArea(child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(16,12,16,0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Upcoming Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              Row(children: [
                GestureDetector(onTap: () => context.push('/events/create'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(999)),
                    child: const Text('➕ Create', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
                const SizedBox(width: 8),
                GestureDetector(onTap: () => context.push('/events/elections'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(999)),
                    child: const Text('🗳 Elections', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
              ]),
            ])),
            Expanded(child: events.isEmpty
              ? const Center(child: EmptyState(title: 'No Events Yet', subtitle: 'No upcoming events available.', icon: Icons.event_rounded))
              : ListView.builder(padding: const EdgeInsets.all(16), itemCount: events.length, itemBuilder: (ctx, i) {
                final ev = events[i];
                final colors = _catColors[ev.category] ?? _catColors['General']!;
                return GestureDetector(
                  onTap: () => context.push('/events/detail/${ev.id}'),
                  child: Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.red.withOpacity(0.10)), boxShadow: [BoxShadow(color: AppTheme.red.withOpacity(0.08), blurRadius: 10, offset: const Offset(0,3))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(height: 80, decoration: BoxDecoration(color: colors[0], borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
                        child: Stack(children: [
                          Center(child: Icon(Icons.event_rounded, size: 42, color: (colors[1]).withOpacity(0.4))),
                          Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: colors[0], borderRadius: BorderRadius.circular(999), border: Border.all(color: colors[1])),
                              child: Text(ev.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: colors[1])))),
                        ])),
                      Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(ev.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        const SizedBox(height: 8),
                        Wrap(spacing: 12, children: [
                          _Meta(Icons.calendar_today_rounded, fmtDate(ev.date)),
                          _Meta(Icons.access_time_rounded, ev.time),
                          _Meta(Icons.location_on_rounded, ev.location),
                        ]),
                      ])),
                    ])),
                ).animate().fadeIn(delay: (i*70).ms).slideY(begin: 0.15);
              })),
          ])),
        );
      },
    );
  }
}

// ── Screen 23: Event Detail ──────────────────────────────────────
class EventDetailScreen extends StatelessWidget {
  final String id;
  const EventDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final ev = dataService.allEvents.firstWhere((x) => x.id == id, orElse: () => Event(
          id: '', title: 'Event Not Found', date: '', time: '', location: '',
          category: '', organizer: '', description: '', status: ''
        ));
        final colors = _catColors[ev.category] ?? _catColors['General']!;
        return Scaffold(
          appBar: _appBar(ev.title, context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
            Container(height: 130, decoration: BoxDecoration(color: colors[0], borderRadius: BorderRadius.circular(18), border: Border.all(color: (colors[1]).withOpacity(0.25))),
              child: Center(child: Icon(Icons.event_rounded, size: 64, color: (colors[1]).withOpacity(0.4)))),
            const SizedBox(height: 14),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              InfoRow(label: 'Date', value: fmtDate(ev.date)),
              InfoRow(label: 'Time', value: ev.time),
              InfoRow(label: 'Location', value: ev.location),
              InfoRow(label: 'Organizer', value: ev.organizer),
              InfoRow(label: 'Category', value: ev.category),
              const Divider(height: 20),
              Text(ev.description, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.7)),
            ]))),
            const SizedBox(height: 6),
            GradientButton(label: '📅 Add to Calendar', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Added to calendar ✓')))),
            const SizedBox(height: 10),
            OutlineBtn(label: '🔔 Remind Me', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Reminder set!')))),
          ])),
        );
      },
    );
  }
}

// ── Screen 24: Elections Info ────────────────────────────────────
class ElectionsInfoScreen extends StatelessWidget {
  const ElectionsInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar('Student Elections 2026', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        NoticeBox(message: 'This is an information-only page. No online voting is conducted here.', borderColor: AppTheme.goldDark, bgColor: AppTheme.gold.withOpacity(0.12), textColor: const Color(0xFF7A5B00), icon: Icons.info_outline_rounded),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionLabel('About'),
          const Text('The Student Council Elections are held annually to elect student representatives. Physical ballot casting is at designated polling stations on campus.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.65)),
          const SectionLabel('Timeline'),
          const _TL('25 Mar 2026', 'Candidate registration closes'),
          const _TL('28–30 Mar 2026', 'Campaigning period'),
          const _TL('1 Apr 2026', 'Polling Day (Block A Foyer, 8am–5pm)'),
          const _TL('2 Apr 2026', 'Results announced'),
          const SectionLabel('Open Positions'),
          ...['President','Vice President','Secretary General','Treasurer'].map((p) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [const Icon(Icons.person_rounded, size: 16, color: AppTheme.red), const SizedBox(width: 8), Text(p, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]))),
        ]))),
        const SectionLabel('Candidates'),
        ...MockData.candidates.map((c) => Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.red.withOpacity(0.1)), boxShadow: [BoxShadow(color: AppTheme.red.withOpacity(0.07), blurRadius: 8, offset: const Offset(0,2))]),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 48, height: 48, decoration: const BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle), child: Center(child: Text(c.name[0], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text(c.programme, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text('Running for: ${c.position}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.red)),
              const SizedBox(height: 4),
              Text(c.manifesto, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.55)),
            ])),
          ])))),
      ])),
    );
  }
}

// ── Screen 25: Admin Events List ─────────────────────────────────
class AdminEventsListScreen extends StatefulWidget {
  const AdminEventsListScreen({super.key});
  @override
  State<AdminEventsListScreen> createState() => _AdminEventsListScreenState();
}

class _AdminEventsListScreenState extends State<AdminEventsListScreen> {
  bool _showPending = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final pendingList = dataService.pendingEvents;
        final publishedList = dataService.allEvents;
        final data = _showPending ? pendingList : publishedList;

        return Scaffold(
          appBar: _appBar('Events Management', context),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/admin/events/editor'),
            backgroundColor: AppTheme.red, icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          body: Column(children: [
            const Padding(padding: EdgeInsets.fromLTRB(16,8,16,0), child: AdminBar()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showPending = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _showPending ? AppTheme.red : Colors.transparent, width: 3)),
                      ),
                      child: Text('Pending (${pendingList.length})', textAlign: TextAlign.center, style: TextStyle(fontWeight: _showPending ? FontWeight.w800 : FontWeight.w600, color: _showPending ? AppTheme.red : AppTheme.textMuted)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showPending = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: !_showPending ? AppTheme.red : Colors.transparent, width: 3)),
                      ),
                      child: Text('Published (${publishedList.length})', textAlign: TextAlign.center, style: TextStyle(fontWeight: !_showPending ? FontWeight.w800 : FontWeight.w600, color: !_showPending ? AppTheme.red : AppTheme.textMuted)),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(child: data.isEmpty
              ? const Center(child: EmptyState(title: 'No Events', subtitle: 'No events to display.', icon: Icons.event_rounded))
              : ListView.builder(padding: const EdgeInsets.fromLTRB(16,16,16,80), itemCount: data.length, itemBuilder: (ctx, i) {
                final ev = data[i];
                if (_showPending) {
                  // Show pending events with approve/reject buttons
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.danger.withOpacity(0.2))),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ev.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${ev.category} · ${fmtDate(ev.date)}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: OutlineBtn(label: 'Reject', onPressed: () {
                              dataService.rejectEvent(ev.id);
                              _toast(ctx, 'Event rejected');
                            })),
                            const SizedBox(width: 8),
                            Expanded(child: GradientButton(label: 'Approve', onPressed: () {
                              dataService.approveEvent(ev.id);
                              _toast(ctx, 'Event approved!');
                            })),
                          ]),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (i*55).ms).slideY(begin:0.12);
                } else {
                  // Show published events
                  return CardRow(
                    title: ev.title,
                    subtitle: '${ev.category} · ${fmtDate(ev.date)}',
                    status: ev.status,
                    onTap: () => context.push('/admin/events/editor/${ev.id}'),
                  ).animate().fadeIn(delay: (i*55).ms).slideY(begin:0.12);
                }
              })),
          ]),
        );
      },
    );
  }
}

// ── Screen 26: Admin Event Editor ───────────────────────────────
class AdminEventEditorScreen extends StatefulWidget {
  final String? id;
  const AdminEventEditorScreen({super.key, this.id});

  @override
  State<AdminEventEditorScreen> createState() => _AdminEventEditorScreenState();
}

class _AdminEventEditorScreenState extends State<AdminEventEditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _timeCtrl;
  late TextEditingController _locCtrl;
  late TextEditingController _orgCtrl;
  String _category = 'Academic';
  String _status = 'Draft';

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _dateCtrl = TextEditingController();
    _timeCtrl = TextEditingController();
    _locCtrl = TextEditingController();
    _orgCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _locCtrl.dispose();
    _orgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final ev = widget.id != null
          ? dataService.allEvents.firstWhere((x) => x.id == widget.id, orElse: () => Event(
              id: '', title: '', date: '', time: '', location: '',
              category: '', organizer: '', description: '', status: ''
            ))
          : null;

        if (ev != null && _titleCtrl.text.isEmpty) {
          _titleCtrl.text = ev.title;
          _descCtrl.text = ev.description;
          _dateCtrl.text = ev.date;
          _timeCtrl.text = ev.time;
          _locCtrl.text = ev.location;
          _orgCtrl.text = ev.organizer;
          _category = ev.category;
          _status = ev.status;
        }

        return Scaffold(
          appBar: _appBar(ev != null ? 'Edit Event' : 'Create Event', context),
          body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
            const AdminBar(), const SizedBox(height: 10),
            TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 12),
            TextFormField(controller: _descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ['Academic','Sport','Club','General'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _category = val ?? _category),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: _dateCtrl, decoration: const InputDecoration(labelText: 'Date'))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _timeCtrl, decoration: const InputDecoration(labelText: 'Time'))),
            ]),
            const SizedBox(height: 12),
            TextFormField(controller: _locCtrl, decoration: const InputDecoration(labelText: 'Location')),
            const SizedBox(height: 12),
            TextFormField(controller: _orgCtrl, decoration: const InputDecoration(labelText: 'Organizer')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['Draft','Under Review','Published','Archived'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _status = val ?? _status),
            ),
            const SizedBox(height: 18),
            GradientButton(
              label: 'Publish',
              onPressed: () {
                if (_titleCtrl.text.isNotEmpty) {
                  _toast(context, 'Event published');
                }
              },
            ),
            const SizedBox(height: 10),
            OutlineBtn(label: 'Save as Draft', onPressed: () => _toast(context, 'Saved as draft')),
            if (ev != null) ...[
              const SizedBox(height: 10),
              OutlineBtn(label: 'Archive', color: AppTheme.danger, onPressed: () => _toast(context, 'Event archived'))
            ],
          ])),
        );
      },
    );
  }
}

// ── Screen 26: Create Event (Student) ─────────────────────────────
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override State<CreateEventScreen> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEventScreen> {
  final _key = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _dateC = TextEditingController();
  final _timeC = TextEditingController();
  final _locC = TextEditingController();
  final _orgC = TextEditingController();
  String? _catVal;
  bool _done = false;

  static const _cats = ['Academic', 'Sport', 'Club', 'General'];

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _dateC.dispose();
    _timeC.dispose();
    _locC.dispose();
    _orgC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 80, height: 80, decoration: const BoxDecoration(color: Color(0x1AC41E3A), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline_rounded, size: 48, color: AppTheme.red)),
          const SizedBox(height: 16),
          const Text('Event Submitted!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Your event is pending admin approval.\nWe\'ll notify you when it\'s approved.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () => context.go('/events'), child: const Text('Back to Events')),
        ]))),
      );
    }

    return Scaffold(
      appBar: _appBar('Create Event', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Form(key: _key, child: Column(children: [
        const NoticeBox(message: 'Your event will be reviewed and approved by admin before publishing.', icon: Icons.info_outline_rounded),
        const SectionLabel('Event Details'),
        TextFormField(controller: _titleC, decoration: const InputDecoration(labelText: 'Event Title', hintText: 'e.g. Tech Talks 2024'), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: _catVal, decoration: const InputDecoration(labelText: 'Category'), items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _catVal = v), validator: (v) => v == null ? 'Required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _dateC, decoration: const InputDecoration(labelText: 'Date', hintText: 'YYYY-MM-DD'), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _timeC, decoration: const InputDecoration(labelText: 'Time', hintText: 'HH:MM'), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _locC, decoration: const InputDecoration(labelText: 'Location', hintText: 'e.g. Auditorium A'), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _orgC, decoration: const InputDecoration(labelText: 'Organizer', hintText: 'Your club/department'), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        TextFormField(controller: _descC, maxLines: 3, decoration: const InputDecoration(labelText: 'Description', hintText: 'Event details...', alignLabelWithHint: true), validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 20),
        GradientButton(label: 'Submit for Approval', onPressed: () {
          if (_key.currentState!.validate() && _catVal != null) {
            final dataService = context.read<DataService>();
            final newEvent = Event(
              id: 'EV-${DateTime.now().millisecondsSinceEpoch}',
              title: _titleC.text,
              category: _catVal!,
              date: _dateC.text,
              time: _timeC.text,
              location: _locC.text,
              organizer: _orgC.text,
              description: _descC.text,
              status: 'Pending',
            );
            dataService.createEvent(newEvent);
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

// ── Screen 27: Admin Elections Management ────────────────────────
class AdminElectionsMgmtScreen extends StatelessWidget {
  const AdminElectionsMgmtScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar('Elections Admin', context),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AdminBar(), const SizedBox(height: 10),
        const SectionLabel('Editable Content Blocks'),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          TextFormField(initialValue: 'The Student Council Elections are held annually…', maxLines: 3, decoration: const InputDecoration(labelText: 'About', alignLabelWithHint: true)),
          const SizedBox(height: 12),
          TextFormField(initialValue: '25 Mar – Registration closes\n1 Apr – Polling Day', maxLines: 3, decoration: const InputDecoration(labelText: 'Timeline', alignLabelWithHint: true)),
          const SizedBox(height: 12),
          TextFormField(initialValue: 'President, Vice President, Secretary General, Treasurer', decoration: const InputDecoration(labelText: 'Open Positions')),
        ]))),
        GradientButton(label: 'Save Content', onPressed: () => _toast(context, 'Content saved')),
        const SectionLabel('Candidates'),
        ...MockData.candidates.map((c) => Card(child: ListTile(
          leading: Container(width: 40, height: 40, decoration: const BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle), child: Center(child: Text(c.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))),
          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${c.programme} · ${c.position}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit_rounded, size: 18, color: AppTheme.red), onPressed: () => _toast(context, 'Edit ${c.name}')),
            IconButton(icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.danger), onPressed: () => _toast(context, 'Candidate removed')),
          ]),
        ))),
      ])),
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────
class _Meta extends StatelessWidget {
  final IconData icon; final String text;
  const _Meta(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 12, color: AppTheme.textMuted), const SizedBox(width: 4),
    Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w600))]);
}

class _TL extends StatelessWidget {
  final String date, text;
  const _TL(this.date, this.text);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 130, child: Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.red))),
    const SizedBox(width: 12),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
  ]));
}
