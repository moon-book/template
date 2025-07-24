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

    // Gom nhóm theo room → day → list<AppointmentMoon>
    for (var appt in appointments) {
      final room = appt.room;
      final day = DateFormat('E').format(appt.startTime); // Mon, Tue, ...

      scheduleMap.putIfAbsent(room, () => {});
      scheduleMap[room]!.putIfAbsent(day, () => []);
      scheduleMap[room]![day]!.add(appt);
    }

    final sortedRooms = scheduleMap.keys.toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade400),
        defaultColumnWidth: FixedColumnWidth(170),
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Phòng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...weekdays.map((day) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),

          // Rows: từng phòng
          ...sortedRooms.map((room) {
            final roomSchedule = scheduleMap[room]!;

            return TableRow(
              children: [
                // Phòng học
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(room, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                // Cột theo thứ
                ...weekdays.map((day) {
                  final appts = roomSchedule[day] ?? [];
                  if (appts.isEmpty) return const SizedBox(height: 60);

                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: appts.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(e.startTime),
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${e.notes}', // ví dụ: MS 7 - Toán Lớp 7
                                style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                e.teacher,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        ],
      ),
    );
  }
}
