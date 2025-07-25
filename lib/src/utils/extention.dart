part of template;

extension DateTimeExt on DateTime {
  String formatDateTimeToddMMyyyy({String? formatString}) {
    // Định dạng DateTime theo dd-MM-yyyy HH:mm
    DateFormat format = DateFormat(formatString ?? 'dd-MM-yyyy');
    return format.format(this);
  }

  DateTime getStartOfDay({DateTime? date}) {
    var d = this;
    return DateTime(d.year, d.month, d.day);
  }

  ///
  bool isSameDay(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }
}

extension StringExt on String {
  String toDateTimeString({String? format}) {
    DateTime dateTime = DateTime.parse(this);
    final String formattedDate = DateFormat(format ?? 'dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  DateTime stringToDateTime() {
    try {
      // Sử dụng DateFormat để phân tích chuỗi với định dạng dd-MM-yyyy HH:mm
      DateFormat format = DateFormat('dd-MM-yyyy');
      return format.parse(this);
    } catch (e) {
      print("Lỗi khi phân tích chuỗi: $e");
      throw e;
    }
  }
}

extension intExt on int {
  String shorten() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    } else {
      return toString();
    }
  }
}
