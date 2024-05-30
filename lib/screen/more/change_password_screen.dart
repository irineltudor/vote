import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vote/service/user_service.dart';
import 'package:vote/widget/code_dialog_widget.dart';

import '../../model/user.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordEditingController =
      TextEditingController();
  final TextEditingController newPasswordEditingController =
      TextEditingController();
  final TextEditingController renewPasswordEditingController =
      TextEditingController();

  final UserService userService = UserService();
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    userService.getUser(user!.uid).then((value) {
      loggedInUser = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final oldPasswordField = TextFormField(
      autofocus: false,
      controller: oldPasswordEditingController,
      obscureText: true,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Current Password is required");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        oldPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.vpn_key_rounded, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current Password",
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

    final newPasswordField = TextFormField(
      autofocus: false,
      controller: newPasswordEditingController,
      obscureText: true,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        newPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.vpn_key_rounded, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "New Password",
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

    final renewPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: renewPasswordEditingController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password is required");
        }

        if (newPasswordEditingController.text !=
            renewPasswordEditingController.text) {
          return ("Passwords don't match");
        }

        return null;
      },
      onSaved: (value) {
        renewPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.vpn_key_rounded, color: theme.scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm New Password",
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

    final updateButton = Material(
      elevation: 3,
      color: theme.primaryColor,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: theme.scaffoldBackgroundColor)),
        onPressed: () {
          changePassword(newPasswordEditingController.text,
              oldPasswordEditingController.text);
        },
        child: Text(
          "Update Password",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge
              ?.copyWith(color: theme.scaffoldBackgroundColor),
        ),
      ),
    );

    oldPasswordEditingController.text = "12345678";
    newPasswordEditingController.text = "12345678";
    renewPasswordEditingController.text = "12345678";

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
        title: Container(
          margin: const EdgeInsets.only(left: 40),
          child: Text(
            "Change Password",
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: height / 1.65,
                width: width / 1.1,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(45))),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        detailContainer(
                            'Current Password', oldPasswordField, 0),
                        const SizedBox(height: 10),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              color:
                                  theme.dialogBackgroundColor.withOpacity(0.25),
                              thickness: 5,
                            )),
                        detailContainer('New Password', newPasswordField, 1),
                        detailContainer(
                            'Confirm New Password', renewPasswordField, 2),
                      ]),
                )),
            updateButton
          ],
        ),
      ),
    );
  }

  Widget detailContainer(String detail, TextFormField field, int index) {
    ThemeData theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 150,
      width: width,
      padding: const EdgeInsets.all(15),
      margin: index == 1
          ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: index == 0
            ? const BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))
            : index == 1
                ? null
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail,
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            ),
            field
          ]),
    );
  }

  void changePassword(String newPassword, String oldPassword) async {
    ThemeData theme = Theme.of(context);
    if (_formKey.currentState!.validate()) {
      List<MultiFactorInfo> mfi = await user!.multiFactor.getEnrolledFactors();

      if (mfi.isEmpty) {
        await userService
            .changePassword(newPassword, oldPassword)
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Password changed succesfully",
                style: theme.textTheme.bodyLarge,
              ),
              backgroundColor: theme.primaryColor,
              showCloseIcon: false,
            ),
          );

          if (value == "good") {
            Navigator.pop(context);
          }
        });
      } else {
        changePasswordWithTwoFactor(newPassword, oldPassword);
      }
    }
  }

  Future<void> changePasswordWithTwoFactor(
      String newPassword, String oldPassword) async {
    ThemeData theme = Theme.of(context);
    String errorMessage = '';
    var credentials = EmailAuthProvider.credential(
        email: user?.email ?? " ", password: oldPassword);

    try {
      await user?.reauthenticateWithCredential(credentials);
    } on FirebaseAuthMultiFactorException catch (e) {
      final firstHint = e.resolver.hints.first;
      if (firstHint is! PhoneMultiFactorInfo) {
        return;
      }
      await FirebaseAuth.instance.verifyPhoneNumber(
        multiFactorSession: e.resolver.session,
        multiFactorInfo: firstHint,
        verificationCompleted: (_) {},
        verificationFailed: (_) {},
        codeSent: (String verificationId, int? resendToken) async {
          // See `firebase_auth` example app for a method of retrieving user's sms code:
          // https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/example/lib/auth.dart#L591
          final smsCode = await await showDialog(
              context: context,
              barrierColor: Colors.black38,
              builder: (BuildContext context) {
                return CodeDialogBox(
                    function: () async {},
                    code: "000000",
                    text: "Type sent code");
              });

          if (smsCode != null) {
            // Create a PhoneAuthCredential with the code
            final credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: smsCode,
            );

            try {
              await e.resolver
                  .resolveSignIn(
                PhoneMultiFactorGenerator.getAssertion(
                  credential,
                ),
              )
                  .then((value) {
                user?.updatePassword(newPassword);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Password changed succesfully",
                    style: theme.textTheme.bodyLarge,
                  ),
                  backgroundColor: theme.primaryColor,
                  showCloseIcon: false,
                ),
              );
              if (mounted) {
                Navigator.pop(context);
              }
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
          }
        },
        codeAutoRetrievalTimeout: (_) {},
      );
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
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "invalid-credential":
          errorMessage = "Your password is invalid.";
          break;
        case 'network-request-failed':
          errorMessage = "No internet connection";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: theme.textTheme.bodyLarge,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
