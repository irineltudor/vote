import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CountryPickerWidget extends StatefulWidget {
  Color color;
  String userCountry;
  Color buttonColor;
  TextEditingController countryOf;

  CountryPickerWidget(
      {Key? key,
      required this.color,
      required this.userCountry,
      required this.buttonColor,
      required this.countryOf})
      : super(key: key);
  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState(
      color: color,
      userCountry: userCountry,
      buttonColor: buttonColor,
      countryOf: countryOf);
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  Country country = Country.worldWide;
  Color color;
  String userCountry;
  Color buttonColor;
  TextEditingController countryOf;
  _CountryPickerWidgetState(
      {required this.color,
      required this.userCountry,
      required this.buttonColor,
      required this.countryOf});

  String getText() {
    if (country.countryCode == "WW") {
      return userCountry;
    } else {
      return country.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Country',
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: color)),
            minWidth: MediaQuery.of(context).size.width / 2,
            onPressed: () => pickCountry(context),
            child: FittedBox(
              child: Text(
                getText(),
                style: TextStyle(fontSize: 16, color: color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future pickCountry(BuildContext context) async {
    showCountryPicker(
        context: context,
        onSelect: (Country newCountry) {
          setState(
              () => {country = newCountry, countryOf.text = newCountry.name});
        });
  }
}
