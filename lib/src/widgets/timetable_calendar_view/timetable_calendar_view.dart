// ignore_for_file: prefer_const_constructors
// ignore_for_file: public_member_api_docs
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:template/src/fork_package/syncfusion_flutter_calendar-27.2.5/lib/calendar.dart';
import 'package:template/template.dart';

import '../weekly_schedule_table.dart';

class TimetableCalendartView extends StatefulWidget {
  const TimetableCalendartView({
    required this.appointments,
    required this.listRoomSession,
    super.key,
    this.onChangeDateFillter,
    this.initialSelectedDate,
  });

  final List<AppointmentMoon> appointments;
  final List<WeeklySessionByRoom> listRoomSession;
  final void Function(DateTime? startDate, DateTime? endDate, bool filterByRoom)? onChangeDateFillter;
  final DateTime? initialSelectedDate;

  @override
  State<TimetableCalendartView> createState() => _TimetableCalendartViewState();
}

class _TimetableCalendartViewState extends State<TimetableCalendartView> {
  CalendarController controller = CalendarController();
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  List<AppointmentMoon> appointments = [];

  @override
  void didUpdateWidget(covariant TimetableCalendartView oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          appointments = widget.appointments
            ..sort(
              (a, b) => a.startTime.compareTo(b.startTime),
            );
        });
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    appointments = widget.appointments
      ..sort(
        (a, b) => a.startTime.compareTo(b.startTime),
      );
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
    final isWeekView = controller.view == CalendarView.week;
    return Portal(
      child: Stack(
        children: [
          if (isWeekView)
            Positioned.fill(
              top: 40,
              child: WeeklyScheduleTable(
                initDate: controller.displayDate ?? DateTime.now(),
                listRoomSession: widget.listRoomSession,
              ),
            ),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final isWeekView = controller.view == CalendarView.week;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        // height: isWeekView ? 40 : null,
        child: SfCalendar(
          view: CalendarView.week,
          controller: controller,
          showDatePickerButton: true,
          showWeekNumber: true,
          firstDayOfWeek: 1,
          showCurrentTimeIndicator: false,
          allowViewNavigation: true,
          showNavigationArrow: true,
          onViewChanged: (details) {
            final dates = details.visibleDates;
            widget.onChangeDateFillter?.call(dates.first, dates.last, controller.view == CalendarView.week);
          },
          onSelectionChanged: (calendarSelectionDetails) {
            if (controller.view == CalendarView.month) {
              controller
                ..view = CalendarView.day
                ..selectedDate = calendarSelectionDetails.date
                ..displayDate = calendarSelectionDetails.date;
            }
          },
          initialSelectedDate: widget.initialSelectedDate ?? DateTime.now(),
          initialDisplayDate: widget.initialSelectedDate ?? DateTime.now(),
          showTodayButton: true,
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: TextStyle(fontSize: 22, color: Colors.white),
          ),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 6,
            timeFormat: 'HH:mm',
            timeIntervalHeight: isWeekView ? 0.001 : 40,
          ),
          viewHeaderStyle: const ViewHeaderStyle(
            backgroundColor: Colors.white,
            dayTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            dateTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          viewHeaderHeight: isWeekView ? 0 : 60,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          resourceViewHeaderBuilder: (BuildContext context, ResourceViewHeaderDetails details) {
            final date = DateTime.now();
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
          scheduleViewMonthHeaderBuilder: (context, details) {
            return Text('data');
          },
          monthViewSettings: MonthViewSettings(
            showTrailingAndLeadingDates: false,
            appointmentDisplayCount: 0,
            monthCellStyle: MonthCellStyle(),
          ),
          monthCellBuilder: (context, details) {
            return Container(
              decoration: BoxDecoration(border: Border.all(width: 0.1)),
              child: Column(
                children: [
                  Text(
                    details.date.day.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          details.appointments.toList().length > 3 ? 3 : details.appointments.toList().length,
                          (index) {
                            final appointment = details.appointments.toList()[index] as AppointmentMoon;
                            return ApointmentMonthItemView(
                              ap: appointment,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (details.appointments.toList().length > 3) ...[
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 4),
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: FittedBox(
                        child: Text(
                          '+${details.appointments.toList().length - 3}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          appointmentBuilder: (context, details) {
            final appointment = details.appointments.toList().first as AppointmentMoon;
            return ApointmentWeekItemView(ap: appointment);
          },
          dataSource: MeetingDataSource(
            appointments,
            // getMeetings(),
          ),
        ),
      ),
    );
  }
}

// DataSource cho lịch
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class ApointmentWeekItemView extends StatefulWidget {
  const ApointmentWeekItemView({required this.ap, super.key});

  final AppointmentMoon ap;

  @override
  State<ApointmentWeekItemView> createState() => _ApointmentWeekItemViewState();
}

class _ApointmentWeekItemViewState extends State<ApointmentWeekItemView> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _showTooltip,
      fit: StackFit.expand,
      anchor: const Aligned(
        follower: Alignment.topCenter, // Tooltip nằm dưới item
        target: Alignment.bottomCenter,
        // widthFactor: 1,
        offset: Offset(-36, 0),
      ),
      portalFollower: MouseRegion(
        onExit: (_) => setState(() => _showTooltip = false),
        onEnter: (_) => setState(() => _showTooltip = true),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              AppBoxShadow.ksSmallShadow(),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(4),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minWidth: 100,
                ),
                child: Text(
                  widget.ap.subject,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.book,
                    // color: Colors.blue,
                    size: 16,
                  ),
                  Gap(4),
                  Text(
                    widget.ap.sessionName,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Gap(2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_2_rounded,
                    // color: Colors.blue,
                    size: 16,
                  ),
                  Gap(4),
                  Text(
                    widget.ap.teacher,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Gap(2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.room,
                    // color: Colors.blue,
                    size: 16,
                  ),
                  Gap(4),
                  Text(
                    widget.ap.room,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.green,
                    size: 16,
                  ),
                  Gap(4),
                  Text(
                    '${DateFormat('HH:mm').format(widget.ap.startTime)} - ${DateFormat('HH:mm').format(widget.ap.endTime)}',
                    style: TextStyle(fontSize: 12),
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  widget.ap.room,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApointmentMonthItemView extends StatefulWidget {
  const ApointmentMonthItemView({required this.ap, super.key});

  final AppointmentMoon ap;

  @override
  State<ApointmentMonthItemView> createState() => _ApointmentMonthItemViewState();
}

class _ApointmentMonthItemViewState extends State<ApointmentMonthItemView> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      height: 30,
      child: PortalTarget(
        visible: _showTooltip,
        fit: StackFit.expand,
        anchor: const Aligned(
          follower: Alignment.topCenter, // Tooltip nằm dưới item
          target: Alignment.bottomCenter,
          widthFactor: 1,
          offset: Offset(0, 10),
        ),
        portalFollower: MouseRegion(
          onExit: (_) => setState(() => _showTooltip = false),
          onEnter: (_) => setState(() => _showTooltip = true),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTap: widget.ap.onDoubleTap,
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(widget.ap.startTime),
                      style: TextStyle(fontSize: 10),
                    ),
                    Gap(4),
                    Expanded(
                      child: Text(
                        widget.ap.subject,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentMoon extends Appointment {
  AppointmentMoon({
    required super.startTime,
    required super.endTime,
    required this.className,
    required this.sessionName,
    required this.teacher,
    required this.room,
    super.color,
    super.notes,
    super.subject,
    this.onDoubleTap,
  });

  String className;
  String sessionName;
  String teacher;
  String room;
  VoidCallback? onDoubleTap;
}

class WeeklySessionByRoom {
  WeeklySessionByRoom({
    required this.roomId,
    required this.roomName,
    required this.session,
  });

  final int roomId;
  final String roomName;
  final List<List<AppointmentMoon>> session;
}
