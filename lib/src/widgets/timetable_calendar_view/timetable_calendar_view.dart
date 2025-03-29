// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:template/src/fork_package/syncfusion_flutter_calendar-27.2.5/lib/calendar.dart';
import 'package:template/template.dart';
import 'package:flutter_portal/flutter_portal.dart';

class TimetableCalendartView extends StatefulWidget {
  const TimetableCalendartView({
    super.key,
    required this.appointments,
    this.onChangeDateFillter,
  });
  final List<Appointment> appointments;
  final Function(DateTime? startDate, DateTime? endDate)? onChangeDateFillter;
  @override
  State<TimetableCalendartView> createState() => _TimetableCalendartViewState();
}

class _TimetableCalendartViewState extends State<TimetableCalendartView> {
  CalendarController controller = CalendarController();
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  @override
  void initState() {
    super.initState();
    selectedStartDate = _getStartOfWeek(DateTime.now()).subtract(const Duration(days: 1));

    selectedEndDate = _getEndOfWeek(DateTime.now()).subtract(const Duration(days: 1));
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getEndOfWeek(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Column(
        children: [
          _renderDatetimePickerRanger(),
          Expanded(
            child: SfCalendar(
              view: CalendarView.week, // Chế độ xem tuần
              controller: controller,
              showDatePickerButton: true,
              showNavigationArrow: true,
              showWeekNumber: true,
              initialSelectedDate: selectedStartDate,
              showCurrentTimeIndicator: true,
              showTodayButton: true,
              headerStyle: CalendarHeaderStyle(
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(fontSize: 22, color: Colors.white),
              ),
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 6,
                endHour: 24,
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
              ),
              viewHeaderStyle: const ViewHeaderStyle(
                backgroundColor: Colors.white,
                dayTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                dateTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              viewHeaderHeight: 60, // Tăng chiều cao phần header

              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
              resourceViewHeaderBuilder: (BuildContext context, ResourceViewHeaderDetails details) {
                final DateTime date = DateTime.now();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEEE').format(date), // Hiển thị Sunday, Monday, ...
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('d').format(date), // Hiển thị ngày (số)
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
              allowAppointmentResize: true,
              appointmentBuilder: (context, details) {
                final appointment = details.appointments.toList().first as Appointment;
                return ApointmentItemView(ap: appointment);
              },
              dataSource: MeetingDataSource(
                widget.appointments,
                // getMeetings(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderDatetimePickerRanger() {
    return SelectedTimeRangeWidget(
      onlyPickRange: true,
      startTimeInit: selectedStartDate,
      endTimeInit: selectedEndDate,
      onSelectDate: (start, end) {
        setState(() {
          controller
            ..selectedDate = start
            ..displayDate = start;
          selectedStartDate = start;
          selectedEndDate = end;
          widget.onChangeDateFillter?.call(start, end);
        });
      },
    );
  }
}

// Dữ liệu lịch
List<Appointment> getMeetings() {
  return <Appointment>[
    Appointment(
      startTime: DateTime(2025, 3, 27, 10, 0),
      endTime: DateTime(2025, 3, 27, 11, 0),
      subject: 'Engineering Sync',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime(2025, 3, 27, 10, 0),
      endTime: DateTime(2025, 3, 27, 14, 0),
      subject: 'Engineering Sync111',
      color: Colors.yellow,
    ),
    Appointment(
      startTime: DateTime(2025, 3, 27, 12, 0),
      endTime: DateTime(2025, 3, 27, 13, 0),
      subject: 'Research Workshop',
      color: Colors.red,
    ),
    Appointment(
      startTime: DateTime(2025, 3, 27, 14, 0),
      endTime: DateTime(2025, 3, 27, 15, 0),
      subject: 'Recap: How we grow',
      color: Colors.green,
    ),
  ];
}

// DataSource cho lịch
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class ApointmentItemView extends StatefulWidget {
  const ApointmentItemView({super.key, required this.ap});
  final Appointment ap;
  @override
  State<ApointmentItemView> createState() => _ApointmentItemViewState();
}

class _ApointmentItemViewState extends State<ApointmentItemView> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _showTooltip,
      fit: StackFit.expand,
      anchor: const Aligned(
        follower: Alignment.bottomLeft,
        target: Alignment.bottomLeft,
        offset: Offset(12, 12),
      ),
      portalFollower: MouseRegion(
        onExit: (_) => setState(() => _showTooltip = false),
        onEnter: (_) => setState(() => _showTooltip = true),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            AppBoxShadow.ksSmallShadow(),
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(4),
              Text(
                widget.ap.subject,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(2),
              Text(
                '${DateFormat('HH:mm').format(widget.ap.startTime)} - ${DateFormat('HH:mm').format(widget.ap.endTime)}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _showTooltip = true),
        onExit: (_) => setState(() => _showTooltip = false),
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
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
                widget.ap.subject,
                style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.ap.notes ?? '',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
