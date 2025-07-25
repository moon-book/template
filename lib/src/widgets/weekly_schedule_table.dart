// ignore_for_file:public_member_api_docs
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template/template.dart';

class WeeklyScheduleTable extends StatelessWidget {
  const WeeklyScheduleTable({
    required this.listData,
    super.key,
  });

  final List<AppointmentMoon> listData;

  @override
  Widget build(BuildContext context) {
    if (listData.isEmpty) {
      return const Text('Không có dữ liệu!');
    } else {
      return _buildRoomScheduleTable(listData);
    }
  }

  Widget _buildRoomScheduleTable(List<AppointmentMoon> appointments) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final scheduleMap = <String, Map<String, List<AppointmentMoon>>>{};

    for (final appt in appointments) {
      final room = appt.room;
      final day = DateFormat('E').format(appt.startTime);

      scheduleMap.putIfAbsent(room, () => {});
      scheduleMap[room]!.putIfAbsent(day, () => []);
      scheduleMap[room]![day]!.add(appt);
    }

    final sortedRooms = scheduleMap.keys.toList()..sort();

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final columnCount = 1 + weekdays.length;
        final columnWidth = totalWidth / columnCount;

        return Column(
          children: [
            Table(
              border: TableBorder.all(color: Colors.grey.shade400),
              defaultColumnWidth: FixedColumnWidth(columnWidth),
              children: [
                // Header row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
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
                      final date = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).add(Duration(days: index));
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
                              decoration: day == DateFormat('dd').format(DateTime.now())
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                              child: Text(
                                day,
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: day == DateFormat('dd').format(DateTime.now()) ?Colors.white:null,
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
                  defaultColumnWidth: FixedColumnWidth(columnWidth),
                  border: TableBorder.all(color: Colors.grey.shade400),
                  children: [
                    ...sortedRooms.map((room) {
                      final roomSchedule = scheduleMap[room]!;

                      return TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            height: 200,
                            child: Center(
                              child: Text(
                                room,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          ...weekdays.map((day) {
                            final appts = roomSchedule[day] ?? [];

                            final morning = appts.where((e) => e.startTime.hour < 12).toList();
                            final afternoon = appts.where((e) => e.startTime.hour >= 12).toList();

                            if (appts.isEmpty) return const SizedBox(height: 60);

                            return SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  // Phần sáng
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                                      child: ListView(
                                        padding: const EdgeInsets.all(4),
                                        children: morning.map((e) => _buildAppointmentBox(e, context)).toList(),
                                      ),
                                    ),
                                  ),

                                  // Divider nếu có cả sáng và chiều
                                  if (morning.isNotEmpty && afternoon.isNotEmpty) const Divider(thickness: 1, height: 1, color: Colors.grey),
                                  // Phần chiều
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                                      child: ListView(
                                        padding: const EdgeInsets.all(4),
                                        children: afternoon.map((e) => _buildAppointmentBox(e, context)).toList(),
                                      ),
                                    ),
                                  ),
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

  Widget _buildAppointmentBox(AppointmentMoon e, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Color.lerp(e.color, Colors.white, 0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            color: e.color, //Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('HH:mm').format(e.startTime),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            e.className,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          Text(
            e.teacher,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
