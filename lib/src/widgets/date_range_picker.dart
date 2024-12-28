part of template;

class SelectedTimeRangeWidget extends StatelessWidget {
  const SelectedTimeRangeWidget({
    super.key,
    required this.startTimeInit,
    required this.endTimeInit,
    required this.onSelectDate,
    this.padding,
    this.decoration,
    this.titleStyle,
    this.menuItem,
  });
  final DateTime startTimeInit;
  final DateTime endTimeInit;
  final Function(DateTime, DateTime) onSelectDate;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final TextStyle? titleStyle;
  final List<MenuItemButton>? menuItem;
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: const MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
      builder: (context, controllerMenu, child) {
        return InkWell(
          onTap: () {
            if (controllerMenu.isOpen) {
              controllerMenu.close();
            } else {
              controllerMenu.open();
            }
          },
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: decoration ??
                BoxDecoration(
                  color: Colors.white,
                  boxShadow: [AppBoxShadow.ksSmallShadow()],
                  borderRadius: BorderRadius.circular(4),
                  // border: Border.all(width: 0.4),
                ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(10),
                Text(
                  "${DateFormat('dd/MM/yyyy').format(startTimeInit)} - ${DateFormat('dd/MM/yyyy').format(endTimeInit)}",
                  style: titleStyle ?? const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: menuItem ??
          [
            MenuItemButton(
              leadingIcon: const Icon(Icons.history),
              child: const Text('Hôm qua'),
              onPressed: () {
                // Ngày hiện tại
                DateTime now = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );

                //ngày hôm qua
                DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
                onSelectDate.call(yesterday, yesterday);
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.timelapse_rounded),
              child: const Text('Hôm nay'),
              onPressed: () {
                // Ngày hiện tại
                DateTime now = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );
                onSelectDate.call(now, now.add(const Duration(days: 1)));
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.date_range),
              child: const Text('7 ngày trước'),
              onPressed: () {
                // Ngày hiện tại
                DateTime now = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );

                //7 ngày trước
                DateTime sevenDayAgo = DateTime(now.year, now.month, now.day - 7);
                onSelectDate.call(sevenDayAgo, now);
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.hourglass_bottom),
              child: const Text('Tháng trước'),
              onPressed: () {
                // Ngày hiện tại
                DateTime now = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );

                //ngày đầu tháng trước
                DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);

                //ngày đầu tháng trước
                DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));

                onSelectDate.call(firstDayOfLastMonth, lastDayOfLastMonth);
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.event_note),
              child: const Text('Tháng này'),
              onPressed: () {
                // Ngày hiện tại
                DateTime s = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  // DateTime.now().day,
                );
                //ngày đầu tháng này
                DateTime e = DateTime(DateTime.now().year, DateTime.now().month + 1);
                onSelectDate.call(s, e);
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(
                Icons.calendar_month,
              ),
              child: Text(
                "${DateFormat('dd/MM/yyyy').format(startTimeInit)} - ${DateFormat('dd/MM/yyyy').format(endTimeInit)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(calendarType: CalendarDatePicker2Type.range),
                  dialogSize: const Size(325, 400),
                  value: [startTimeInit, endTimeInit],
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null) {
                  onSelectDate.call(results.firstOrNull!, results.lastOrNull!);
                }
              },
            ),
          ],
    );
  }
}
