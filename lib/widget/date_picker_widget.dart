import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatefulWidget {
  String userDate;
  Color buttonColor;
  TextEditingController dob;

  DatePickerWidget(
      {super.key,
      required this.userDate,
      required this.buttonColor,
      required this.dob});
  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime date = DateTime(0);
  late String userDate = widget.userDate;
  late Color buttonColor = widget.buttonColor;
  late TextEditingController dob = widget.dob;

  String getText() {
    if (date.year == 0) {
      return userDate;
    } else {
      return DateFormat('MM-dd-yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            color: theme.scaffoldBackgroundColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: theme.scaffoldBackgroundColor)),
            minWidth: MediaQuery.of(context).size.width / 2,
            onPressed: () => pickDate(context),
            child: FittedBox(
              child: Text(
                getText(),
                style: TextStyle(
                    fontSize: 16, color: theme.scaffoldBackgroundColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    ThemeData theme = Theme.of(context);

    if (date.year != 0) {}

    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 6574)),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(DateTime.now().year - 120),
        lastDate: DateTime.now().subtract(const Duration(days: 6574)),
        builder: (context, widget) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: theme.primaryColor,
                onPrimary: theme.dialogBackgroundColor,
                surface: theme.primaryColor,
                onSurface: theme.dialogBackgroundColor,
              ),
              dialogBackgroundColor: theme.scaffoldBackgroundColor,
            ),
            child: widget!,
          );
        });

    if (newDate == null) return;

    setState(() {
      date = newDate;
      dob.text = DateFormat('MM-dd-yyyy').format(newDate);
    });
  }
}
