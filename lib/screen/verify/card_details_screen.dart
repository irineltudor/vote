import 'dart:collection';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vote/service/user_service.dart';
import '../../service/storage_service.dart';

import '../../model/user.dart';

class CardDetailsScreen extends StatefulWidget {
  final Function function;
  const CardDetailsScreen({super.key, required this.function});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  TextEditingController addressTEController = TextEditingController(),
      cityTEController = TextEditingController(),
      countyTEController = TextEditingController(),
      countryTEController = TextEditingController(),
      dobTEController = TextEditingController(),
      expireDateTEController = TextEditingController(),
      issueDateTEController = TextEditingController(),
      firstnameTEController = TextEditingController(),
      lastnameTEController = TextEditingController(),
      genderTEController = TextEditingController(),
      nationalityTEController = TextEditingController(),
      personalCodeTEController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();
  final StorageService storageService = StorageService();
  File? _idCardPicture;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      setState(() {});
    });
  }

  void _startUpload() {
    String path = 'idcard/${loggedInUser.uid!}.png';
    storageService.uploadFile(path, _idCardPicture!);
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);

    setState(() {
      if (selected != null) _idCardPicture = File(selected.path);
    });
  }

  void _clear() {
    setState(() => _idCardPicture = null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    final photoButtons = Card(
        shadowColor: Colors.black45,
        elevation: 5,
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                Icons.image,
                color: theme.primaryColor,
                size: 17,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      "ID CARD PHOTO",
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                      child: Text(_idCardPicture == null
                          ? 'Add Id Card Photo'
                          : 'Id Card Photo')),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library,
                          color: theme.primaryColor, size: 20),
                      onPressed: () => _pickImage(
                        ImageSource.gallery,
                      ),
                    )
                  ],
                )),
          ],
        ));

    setState(() {
      addressTEController.text = 'Sarmisegetuza 12';
      cityTEController.text = 'Iasi';
      countyTEController.text = 'Iasi';
      countryTEController.text = 'Romania';
      dobTEController.text = '09-11-2000';
      expireDateTEController.text = '09-11-2028';
      issueDateTEController.text = '09-11-2022';
      firstnameTEController.text = 'Tudor Irinel';
      lastnameTEController.text = 'Urma';
      genderTEController.text = 'M';
      nationalityTEController.text = 'romanian';
      personalCodeTEController.text = '5000911222493';
    });

    if (loggedInUser.firstname == null) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          margin:
              const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 18,
              ),
              Text('Enter ID Card Details',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(
                height: 5,
              ),
              Text('To verify your Account, please enter your id card details.',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: [
                      _dataField(
                          text: 'First Name',
                          hint: 'First Name',
                          icon: Icons.person,
                          textEditingController: firstnameTEController,
                          theme: theme),
                      _dataField(
                          text: 'Last Name',
                          hint: 'Last Name',
                          icon: Icons.person,
                          textEditingController: lastnameTEController,
                          theme: theme),
                      _personalCodeField(
                          textEditingController: personalCodeTEController,
                          theme: theme),
                      _genderField(
                          text: 'Sex',
                          hint: 'M or F',
                          icon: Icons.person,
                          textEditingController: genderTEController,
                          theme: theme),
                      _dataField(
                          text: 'Nationality',
                          hint: 'Nationality',
                          icon: Icons.home,
                          textEditingController: nationalityTEController,
                          theme: theme),
                      _dataField(
                          text: 'Country',
                          hint: 'Country',
                          icon: Icons.home,
                          textEditingController: countryTEController,
                          theme: theme),
                      _dataField(
                          text: 'County',
                          hint: 'County',
                          icon: Icons.home,
                          textEditingController: countyTEController,
                          theme: theme),
                      _dataField(
                          text: 'City',
                          hint: 'City',
                          icon: Icons.home,
                          textEditingController: cityTEController,
                          theme: theme),
                      _dataField(
                          text: 'Address',
                          hint: 'Address',
                          icon: Icons.home,
                          textEditingController: addressTEController,
                          theme: theme),
                      _dateField(
                          text: 'Date of Birth',
                          hint: 'MM-DD-YYYY',
                          icon: Icons.calendar_month_outlined,
                          textEditingController: dobTEController,
                          theme: theme),
                      _dateField(
                          text: 'Date of Card Issue',
                          hint: 'MM-DD-YYYY',
                          icon: Icons.calendar_month_outlined,
                          textEditingController: issueDateTEController,
                          theme: theme),
                      _dateField(
                          text: 'Date of Card Expire',
                          hint: 'MM-DD-YYYY',
                          icon: Icons.calendar_month_outlined,
                          textEditingController: expireDateTEController,
                          theme: theme),
                      photoButtons,
                      if (_idCardPicture != null) ...[
                        Image.file(_idCardPicture!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: _clear,
                                child: const Icon(Icons.delete))
                          ],
                        ),
                      ],
                      SizedBox(
                        height: height / 4.5,
                      ),
                    ],
                  ),
                ),
              ),
              _next(theme: theme),
            ],
          ),
        ),
      );
    }
  }

  Widget _next({required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            postDetailsToDB();
          },
          child: Text(
            "Update",
            style:
                theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _personalCodeField(
      {required TextEditingController textEditingController,
      required ThemeData theme}) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.only(top: 2.0, bottom: 5.0),
      child: Container(
        margin:
            const EdgeInsets.only(top: 2.0, bottom: 1.0, left: 0.0, right: 0.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                height: 45,
                margin: const EdgeInsets.only(left: 3.0, right: 7.0),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Code',
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Image.asset("assets/verify/Carte-identitate-scaled.jpg",
                          width: 40, height: 30),
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          onSaved: (value) {
                            textEditingController.text = value!;
                          },
                          decoration: InputDecoration(
                            hintText: 'XXXXXXXXXXXXX',
                            hintStyle: theme.textTheme.bodySmall,
                            border: InputBorder.none,
                            errorStyle: theme.textTheme.labelMedium,
                            isDense: true,
                            contentPadding: const EdgeInsets.only(left: 5.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Personal Code cannot be empty");
                            }

                            if (value.length != 13) {
                              return ("Enter a valid personal number(13 characters)");
                            }

                            return null;
                          },
                          style: theme.textTheme.bodyMedium,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderField({
    required String text,
    required String hint,
    required IconData icon,
    required TextEditingController textEditingController,
    required ThemeData theme,
  }) {
    return Card(
        shadowColor: Colors.black45,
        elevation: 5,
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: theme.textTheme.bodySmall,
                        errorStyle: theme.textTheme.labelMedium,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'M|F');
                        if (value!.isEmpty) {
                          return ("$text cannot be empty");
                        }

                        if (!regex.hasMatch(value)) {
                          return ("Enter a valid sex(M or F)");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        textEditingController.text = value!;
                      },
                      style: theme.textTheme.bodyMedium,
                      textInputAction: TextInputAction.done,
                      keyboardType: (hint == "MM-DD-YYYY")
                          ? TextInputType.number
                          : TextInputType.text,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _dateField({
    required String text,
    required String hint,
    required IconData icon,
    required TextEditingController textEditingController,
    required ThemeData theme,
  }) {
    return Card(
        shadowColor: Colors.black45,
        elevation: 5,
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextFormField(
                      controller: textEditingController,
                      validator: (value) {
                        RegExp regex = RegExp(
                            r'(0[1-9]|1[1,2])\-(0[1-9]|[12][0-9]|3[01])\-(19|20)\d{2}');
                        if (value!.isEmpty) {
                          return ("$text cannot be empty");
                        }

                        if (!regex.hasMatch(value)) {
                          return ("Enter a date (MM-DD-YY)");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        textEditingController.text = value!;
                      },
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: theme.textTheme.bodySmall,
                        errorStyle: theme.textTheme.labelMedium,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      style: theme.textTheme.bodyMedium,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _dataField({
    required String text,
    required String hint,
    required IconData icon,
    required TextEditingController textEditingController,
    required ThemeData theme,
  }) {
    return Card(
        shadowColor: Colors.black45,
        elevation: 5,
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 17,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 5, bottom: 3),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: theme.textTheme.bodySmall,
                        errorStyle: theme.textTheme.labelMedium,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("$text cannot be empty");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        textEditingController.text = value!;
                      },
                      style: theme.textTheme.bodyMedium,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  postDetailsToDB() async {
    ThemeData theme = Theme.of(context);

    if (_formKey.currentState!.validate()) {
      if (_idCardPicture == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Add Id Card Photo"),
          ));
        }
      } else {
        widget.function.call(true);
        _startUpload();
        LinkedHashMap<String, String> idCard = LinkedHashMap();

        idCard['firstname'] = firstnameTEController.text;
        idCard['lastname'] = lastnameTEController.text;
        idCard['sex'] = genderTEController.text;
        idCard['nationality'] = nationalityTEController.text;
        idCard['country'] = countryTEController.text;
        idCard['county'] = countyTEController.text;
        idCard['city'] = cityTEController.text;
        idCard['address'] = addressTEController.text;
        idCard['dob'] = dobTEController.text;
        idCard['personalCode'] = personalCodeTEController.text;
        idCard['issueDate'] = issueDateTEController.text;
        idCard['expireDate'] = expireDateTEController.text;

        userService.updateIdCard(loggedInUser, idCard);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(100, 0, 100, 400),
              duration: const Duration(seconds: 1),
              content: const Text(
                "Details Updated",
              ),
              backgroundColor: theme.primaryColor,
            ),
          );
        }
      }
    }
  }
}
