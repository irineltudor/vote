// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fiteat/model/diary.dart';
// import 'package:fiteat/model/user_model.dart';
// import 'package:fiteat/screens/home/home_screen.dart';
// import 'package:fiteat/screens/signup-signin/details_screen.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote/screen/navigator/navigator_screen.dart';
import 'package:vote/service/user_service.dart';

import '../../model/user.dart';
import '../../widget/date_picker_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  final birthEditingController = TextEditingController();
  final countryEditingController = TextEditingController();

  final UserService userService = UserService();

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDarkMode = theme.brightness == Brightness.dark;
    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid name(min 3 characters)");
        }

        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

    //second name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Last Name cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid name(min 3 characters)");
        }

        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Last Name",
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

    //date picker
    final datePicker = DatePickerWidget(
        userDate: 'Pick Date',
        buttonColor: Colors.transparent,
        dob: birthEditingController);

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }

        //reg ex for email valid
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }

        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for registration");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.vpn_key_rounded, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Confirmt Password is required for registration");
        }
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return ("Passwords don't match");
        }

        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.vpn_key_rounded, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

//sign up button
    final signUpButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: theme.primaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: theme.scaffoldBackgroundColor)),
        minWidth: MediaQuery.of(context).size.width / 1.5,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.scaffoldBackgroundColor),
        ),
      ),
    );

    firstNameEditingController.text = "Tudor";
    lastNameEditingController.text = "Urma";
    emailEditingController.text = "tirynel@yahoo.com";
    passwordEditingController.text = "12345678";
    confirmPasswordEditingController.text = "12345678";

    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.scaffoldBackgroundColor),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 36, right: 36),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      isDarkMode
                          ? "assets/logo/dark/logo.png"
                          : "assets/logo/light/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: [
                      Text("Your vote counts,",
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(color: theme.scaffoldBackgroundColor)),
                      Text("Create a new account",
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: theme.scaffoldBackgroundColor)),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        firstNameField,
                        const SizedBox(height: 20),
                        lastNameField,
                        const SizedBox(height: 20),
                        emailField,
                        const SizedBox(height: 20),
                        datePicker,
                        const SizedBox(height: 20),
                        passwordField,
                        const SizedBox(height: 20),
                        confirmPasswordField,
                        const SizedBox(height: 25),
                        signUpButton,
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      if (birthEditingController.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Select birth date"),
        ));
      } else {
        try {
          await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) => {postDetailsToDB()});
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = error.message;
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(errorMessage!),
            ));
          }
        }
      }
    }
  }

  postDetailsToDB() async {
    //calling our firestore
    //calling our usermodel
    //sending these valuse

    User? user = _auth.currentUser;

    LinkedHashMap<String, String> idCard = LinkedHashMap();

    idCard['firstname'] = "";
    idCard['lastname'] = "";
    idCard['sex'] = "";
    idCard['nationality'] = "";
    idCard['country'] = "";
    idCard['county'] = "";
    idCard['city'] = "";
    idCard['address'] = "";
    idCard['dob'] = "";
    idCard['personalCode'] = "";
    idCard['issueDate'] = "";
    idCard['expireDate'] = "";

    UserModel userModel = UserModel(
        uid: user!.uid,
        email: user.email,
        firstname: firstNameEditingController.text,
        lastname: lastNameEditingController.text,
        dob: birthEditingController.text,
        status: 0,
        pin: "",
        phoneNumber: "",
        idCard: idCard);

    userService.addUser(userModel);

    await user.sendEmailVerification();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const NavigatorScreen()),
          (route) => false);
    }
  }
}
