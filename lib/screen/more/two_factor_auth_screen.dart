import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/widget/code_dialog_widget.dart';

import '../../model/user.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final UserService userService = UserService();

  final phoneNumberEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (loggedInUser.firstname == null) {
      return Container(
          color: theme.primaryColor,
          child: Center(
              child: CircularProgressIndicator(
            color: theme.scaffoldBackgroundColor,
          )));
    } else {
      final sendCodeButton = Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(30),
        color: theme.primaryColor,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minWidth: MediaQuery.of(context).size.width / 1.5,
          onPressed: () {
            sendCode(phoneNumberEditingController.text);
          },
          child: Text(
            "Send the code",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
        ),
      );

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.primaryColor,
            ),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
          title: Container(
            margin: const EdgeInsets.only(left: 110),
            child: Text(
              "2FA",
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: theme.primaryColor),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(40),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                      "assets/animations/phoneverif_animation.json"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Set up phone number:",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We need to register your phone number for two factor authenticator",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          IntlPhoneField(
                            keyboardType: TextInputType.phone,
                            initialCountryCode: "RO",
                            decoration: InputDecoration(
                                labelText: "Phone Number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            onChanged: (phone) {
                              phoneNumberEditingController.text =
                                  phone.completeNumber;
                            },
                          ),
                          sendCodeButton,
                        ],
                      ))
                ]),
          ),
        ),
      );
    }
  }

  void sendCode(String phoneNumber) async {
    if (_formKey.currentState!.validate()) {
      final multiFactorSession = await user?.multiFactor.getSession();

      await FirebaseAuth.instance.verifyPhoneNumber(
        multiFactorSession: multiFactorSession,
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException exception) {
          if (exception.code == "second-factor-already-enrolled") {
            Fluttertoast.showToast(
              msg:
                  "Phone number already enrolled as second factor for this account.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
            );
            Navigator.of(context).pop("refresh");
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          // The SMS verification code has been sent to the provided phone number.
          final smsCode = await showDialog(
              context: context,
              barrierColor: Colors.black38,
              builder: (BuildContext context) {
                return CodeDialogBox(
                    function: () async {},
                    code: "000000",
                    text: "Enter sent code $phoneNumber");
              });

          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );

          try {
            await user!.multiFactor
                .enroll(
                  PhoneMultiFactorGenerator.getAssertion(
                    credential,
                  ),
                )
                .then((value) => {
                      Fluttertoast.showToast(
                        msg: "Two factor authenticator updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                      ),
                      userService.updatePhoneNumber(loggedInUser, phoneNumber),
                      Navigator.of(context).pop("refresh"),
                      setState(() {})
                    });
          } on FirebaseAuthException catch (e) {
            switch (e.code) {
              case "invalid-verification-code":
                Fluttertoast.showToast(
                  msg: "Invalid Code Try Again",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                );
              default:
                Fluttertoast.showToast(
                  msg: e.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                );
            }
          }
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    }
  }
}
