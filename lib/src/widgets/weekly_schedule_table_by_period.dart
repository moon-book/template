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
    final weekdays = ['Mon', 'Tue', 'Thu', 'Wed', 'Fri', 'Sat', 'Sun'];

    List<AppointmentMoon> getSession(List<List<AppointmentMoon>> session, int index) {
      if (session.length > index) return session[index];
      return [];
    }

    const double appointmentHeight = 80; // mỗi appointment cao 80px
    const double minRoomHeight = 80;     // tối thiểu mỗi phòng 80px

    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      const fixedWidth = 150.0;
      final dayWidth = (totalWidth - fixedWidth * 2) / weekdays.length;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Row(
              children: [
                Container(
                  width: fixedWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400,width: 0.5),
                  ),
                  child: const Text('CA HỌC', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: fixedWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400,width: 0.5),
                  ),
                  child: const Text('PHÒNG HỌC', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...weekdays.map((d) => Container(
                  width: dayWidth,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400,width: 0.5),
                  ),
                  child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),

            // ===== NỘI DUNG =====
            ...periods.map((period) {
              // Tính chiều cao từng phòng = số appointment nhiều nhất trong ngày của phòng
              final roomHeights = period.session.map((room) {
                var maxAppointmentsInRoom = 0;
                for (var day in weekdays) {
                  final morningCount = getSession(room.session, 0)
                      .where((e) => DateFormat('E').format(e.startTime) == day)
                      .length;
                  final afternoonCount = getSession(room.session, 1)
                      .where((e) => DateFormat('E').format(e.startTime) == day)
                      .length;
                  final total = morningCount + afternoonCount;
                  if (total > maxAppointmentsInRoom) maxAppointmentsInRoom = total;
                }
                return (maxAppointmentsInRoom > 0 ? maxAppointmentsInRoom * appointmentHeight : minRoomHeight);
              }).toList();

              final totalPeriodHeight = roomHeights.fold(0.0, (sum, h) => sum + h);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Cột Ca HỌC =====
                  Container(
                    width: fixedWidth,
                    height: totalPeriodHeight,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400,width: 0.5),
                    ),
                    child: Text(period.periodName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),

                  // ===== Cột PHÒNG =====
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
                          border: Border.all(color: Colors.grey.shade400,width: 0.5),
                        ),
                        child: Text(room.roomName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }),
                  ),

                  // ===== Cột BUỔI HỌC THEO NGÀY =====
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(period.session.length, (i) {
                      final room = period.session[i];
                      final roomHeight = roomHeights[i];

                      return Row(
                        children: weekdays.map((day) {
                          final morning = getSession(room.session, 0)
                              .where((e) => DateFormat('E').format(e.startTime) == day)
                              .toList();
                          final afternoon = getSession(room.session, 1)
                              .where((e) => DateFormat('E').format(e.startTime) == day)
                              .toList();

                          return Container(
                            width: dayWidth,
                            height: roomHeight,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400,width: 0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...morning.map((e) => _AppointmentItemView(ap: e)),
                                if (morning.isNotEmpty && afternoon.isNotEmpty)
                                  const Divider(height: 1, thickness: 1, color: Colors.grey),
                                ...afternoon.map((e) => _AppointmentItemView(ap: e)),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
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
      ),
    );
  }
}
