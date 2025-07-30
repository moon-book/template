// ignore_for_file:public_member_api_docs
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:template/template.dart';

class WeeklyScheduleTable extends StatelessWidget {
  const WeeklyScheduleTable({
    required this.initDate,
    required this.listRoomSession, super.key,
  });

  final DateTime initDate;
  final List<WeeklySessionByRoom> listRoomSession;

  @override
  Widget build(BuildContext context) {
    if (listRoomSession.isEmpty) {
      return const Text('Không có dữ liệu!');
    } else {
      return _buildRoomScheduleTable(listRoomSession);
    }
  }

  Widget _buildRoomScheduleTable(List<WeeklySessionByRoom> appointments) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final columnWidth = (totalWidth - 150) / weekdays.length;

        final columnWidths = <int, TableColumnWidth>{
          0: const FixedColumnWidth(150),
          1: FixedColumnWidth(columnWidth),
          2: FixedColumnWidth(columnWidth),
          3: FixedColumnWidth(columnWidth),
          4: FixedColumnWidth(columnWidth),
          5: FixedColumnWidth(columnWidth),
          6: FixedColumnWidth(columnWidth),
          7: FixedColumnWidth(columnWidth),
        };

        return Column(
          children: [
            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              columnWidths: columnWidths,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header row
                TableRow(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Center(
                        child: Text(
                          'PHÒNG HỌC',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ...List.generate(7, (index) {
                      final date = initDate.subtract(Duration(days: initDate.weekday - 1)).add(Duration(days: index));
                      final weekday = DateFormat('E').format(date);
                      final day = DateFormat('dd').format(date);
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              weekday.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: date.isSameDay(DateTime.now())
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: day == DateFormat('dd').format(DateTime.now()) ? Colors.white : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Table(
                  // defaultColumnWidth: FixedColumnWidth(columnWidth),
                  border: TableBorder.all(color: Colors.grey.shade400),
                  columnWidths: columnWidths,
                  children: [
                    ...listRoomSession.map((roomData) {
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.fill,
                            child: Container(
                              color: Colors.grey.shade200,
                              constraints: const BoxConstraints(minHeight: 60),
                              child: Center(
                                child: Text(
                                  roomData.roomName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          ...weekdays.map((day) {
                            final morning = roomData.session[0].where((e) {
                              return DateFormat('E').format(e.startTime) == day;
                            }).toList();

                            final afternoon = roomData.session[1].where((e) {
                              return DateFormat('E').format(e.startTime) == day;
                            }).toList();

                            return Container(
                              constraints: const BoxConstraints(minHeight: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Gap(8),
                                  ListView(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: morning.map((e) => _AppointmentItemView(ap: e)).toList(),
                                  ),
                                  if (morning.isNotEmpty && afternoon.isNotEmpty)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4),
                                      child: Divider(thickness: 1, height: 1, color: Colors.grey),
                                    ),
                                  ListView(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: afternoon.map((e) => _AppointmentItemView(ap: e)).toList(),
                                  ),
                                  const Gap(8),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AppointmentItemView extends StatefulWidget {
  const _AppointmentItemView({required this.ap});

  final AppointmentMoon ap;

  @override
  State<_AppointmentItemView> createState() => _AppointmentItemViewState();
}

class _AppointmentItemViewState extends State<_AppointmentItemView> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      height: 60,
      child: PortalTarget(
        visible: _showTooltip,
        fit: StackFit.expand,
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
          widthFactor: 1,
          offset: Offset(0, 10),
        ),
        portalFollower: MouseRegion(
          onExit: (_) => setState(() => _showTooltip = false),
          onEnter: (_) => setState(() => _showTooltip = true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                AppBoxShadow.ksSmallShadow(),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(4),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                    minWidth: 100,
                  ),
                  child: Text(
                    widget.ap.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.book,
                      // color: Colors.blue,
                      size: 16,
                    ),
                    const Gap(4),
                    Text(
                      widget.ap.sessionName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Gap(2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_2_rounded,
                      // color: Colors.blue,
                      size: 16,
                    ),
                    const Gap(4),
                    Text(
                      widget.ap.teacher,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Gap(2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.room,
                      // color: Colors.blue,
                      size: 16,
                    ),
                    const Gap(4),
                    Text(
                      widget.ap.room,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.green,
                      size: 16,
                    ),
                    const Gap(4),
                    Text(
                      '${DateFormat('HH:mm').format(widget.ap.startTime)} - ${DateFormat('HH:mm').format(widget.ap.endTime)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _showTooltip = true),
          onExit: (_) => setState(() => _showTooltip = false),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: widget.ap.onDoubleTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color.lerp(widget.ap.color, Colors.white, 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border(
                  left: BorderSide(
                    color: widget.ap.color, //Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ap.className,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: DateFormat('HH:mm').format(widget.ap.startTime),
                          style: const TextStyle(fontSize: 12,),
                        ),
                        const TextSpan(
                          text: ' - ',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: widget.ap.teacher,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
