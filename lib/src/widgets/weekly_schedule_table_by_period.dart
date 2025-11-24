// ignore_for_file:public_member_api_docs
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:template/template.dart';

class WeeklyScheduleTableByPeriod extends StatelessWidget {
  const WeeklyScheduleTableByPeriod({
    required this.initDate,
    required this.listRoomSession,
    super.key,
  });

  final DateTime initDate;
  final List<WeeklySessionByPeriod> listRoomSession;

  @override
  Widget build(BuildContext context) {
    if (listRoomSession.isEmpty) {
      return const Text('Không có dữ liệu!');
    } else {
      return buildScheduleByPeriodWithBorder(listRoomSession);
    }
  }

  Widget buildScheduleByPeriodWithBorder(List<WeeklySessionByPeriod> periods) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    List<AppointmentMoon> getSession(List<List<AppointmentMoon>> session, int index) {
      if (session.length > index) return session[index];
      return [];
    }

    const double appointmentHeight = 55;
    const double minRoomHeight = 60;

    final today = DateTime.now();

    final normalizedInit = DateTime(initDate.year, initDate.month, initDate.day);

    final daysToSubtract = normalizedInit.weekday - DateTime.monday; // = weekday - 1
    final startOfWeek = normalizedInit.subtract(Duration(days: daysToSubtract));

    final weekDates = List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      const fixedWidth = 150.0;
      final dayWidth = (totalWidth - fixedWidth * 2) / weekdays.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: fixedWidth,
                padding: const EdgeInsets.all(14.5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 0.3),
                ),
                child: const Text('CA HỌC', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                width: fixedWidth,
                padding: const EdgeInsets.all(14.5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 0.3),
                ),
                child: const Text('PHÒNG HỌC', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...List.generate(7, (i) {
                final weekdayName = weekdays[i];
                final date = weekDates[i];

                final dateText = DateFormat('dd').format(date);

                final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

                return Container(
                  width: dayWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 0.3),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekdayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isToday
                            ? BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange, width: 1.0),
                              )
                            : null,
                        child: Text(
                          dateText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const Gap(4),
                    ],
                  ),
                );
              }),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                ...periods.map((period) {
                  final roomHeights = period.session.map((room) {
                    double maxHeight = 0;

                    for (var dayIndex = 0; dayIndex < weekdays.length; dayIndex++) {
                      final day = weekdays[dayIndex];

                      double dayHeight = 0;

                      for (var sessionIndex = 0; sessionIndex < room.session.length; sessionIndex++) {
                        final appointments = getSession(room.session, sessionIndex).where((e) => DateFormat('E').format(e.startTime) == day).toList();

                        final slotCount = appointments.isEmpty ? 1 : appointments.length;

                        dayHeight += slotCount * appointmentHeight + 10; // +4 là gap padding
                      }

                      if (dayHeight > maxHeight) maxHeight = dayHeight;
                    }

                    return maxHeight < minRoomHeight ? minRoomHeight : maxHeight + 20;
                  }).toList();

                  final totalPeriodHeight = roomHeights.fold(0.0, (sum, h) => sum + h);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: fixedWidth,
                        height: totalPeriodHeight,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade800, width: 0.25),
                            top: BorderSide(color: Colors.grey.shade400, width: 0.25),
                            right: BorderSide(color: Colors.grey.shade400, width: 0.25),
                            left: BorderSide(color: Colors.grey.shade400, width: 0.25),
                          ),
                        ),
                        child: Text(period.periodName, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(period.session.length, (i) {
                          final room = period.session[i];
                          final roomHeight = roomHeights[i];
                          return Container(
                            width: fixedWidth,
                            height: roomHeight,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: i == period.session.length - 1 ? Colors.grey.shade800 : Colors.grey.shade400, width: 0.25),
                                top: BorderSide(color: Colors.grey.shade400, width: 0.25),
                                right: BorderSide(color: Colors.grey.shade400, width: 0.25),
                                left: BorderSide(color: Colors.grey.shade400, width: 0.25),
                              ),
                            ),
                            child: Text(room.roomName, style: const TextStyle(fontWeight: FontWeight.w500)),
                          );
                        }),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(period.session.length, (i) {
                          final room = period.session[i];
                          final roomHeight = roomHeights[i];

                          return Row(
                            children: weekdays.map((day) {
                              return Container(
                                width: dayWidth,
                                height: roomHeight,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: i == period.session.length - 1 ? Colors.grey.shade800 : Colors.grey.shade400,
                                      width: 0.25,
                                    ),
                                    top: BorderSide(color: Colors.grey.shade400, width: 0.25),
                                    right: BorderSide(color: Colors.grey.shade400, width: 0.25),
                                    left: BorderSide(color: Colors.grey.shade400, width: 0.25),
                                  ),
                                ),

                                /// Render N session blocks
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(room.session.length, (sessionIndex) {
                                    final currentList =
                                        getSession(room.session, sessionIndex).where((e) => DateFormat('E').format(e.startTime) == day).toList();

                                    return SizedBox(
                                      height: (currentList.isEmpty ? 1 : currentList.length) * appointmentHeight + 12,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Gap(4),
                                          Expanded(
                                            child: currentList.isEmpty
                                                ? const SizedBox.shrink()
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: currentList.map((e) => _AppointmentItemView(ap: e)).toList(),
                                                  ),
                                          ),
                                          const Gap(4),
                                          if (sessionIndex < room.session.length - 1) const Divider(height: 1, thickness: 1) else const Gap(1),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      )
                    ],
                  );
                })
              ]),
            ),
          ),
        ],
      );
    });
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
        height: 53,
        child: PortalTarget(
          visible: _showTooltip,
          fit: StackFit.expand,
          anchor: const Aligned(
            follower: Alignment.bottomCenter,
            target: Alignment.topCenter,
            widthFactor: 1,
            offset: Offset(0, -10),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.payments_rounded,
                        size: 16,
                      ),
                      const Gap(4),
                      RichText(
                        text: TextSpan(
                          text: 'Full phí: ',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '${widget.ap.studentFullFee}',
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        size: 16,
                      ),
                      const Gap(4),
                      RichText(
                        text: TextSpan(
                          text: 'Học thử: ',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '${widget.ap.studentTrial}',
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.attach_money_rounded,
                        size: 16,
                      ),
                      const Gap(4),
                      RichText(
                        text: TextSpan(
                          text: 'Đặt cọc: ',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                          children: [
                            TextSpan(
                              text: '${widget.ap.studentPrepaid}',
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
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
                            style: const TextStyle(
                              fontSize: 12,
                            ),
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
        ));
  }
}
