import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
        RegExp regex = new RegExp(r'^.{6,}$');
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
        RegExp regex = new RegExp(r'^.{6,}$');
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
                    borderRadius: BorderRadius.all(Radius.circular(45))),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        detailContainer(
                            'Current Password', oldPasswordField, 0),
                        SizedBox(height: 10),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
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
          ? EdgeInsets.symmetric(horizontal: 15, vertical: 10)
          : EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: index == 0
            ? BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))
            : index == 1
                ? null
                : BorderRadius.only(
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

  Future<void> changePassword(String newPassword, String oldPassword) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      //  var credentials = EmailAuthProvider.credential(email: user?.email ?? " " , password: oldPassword);
      //  try{
      //   await user?.reauthenticateWithCredential(credentials).then((value) => {
      //  user?.updatePassword(newPassword).then((value) => {errorMessage = "Successfully changed password",Fluttertoast.showToast(msg: '$errorMessage'),Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MoreScreen()))}).catchError((onError){
      //         errorMessage = "Password can't be changed" + onError.toString();
      //         Fluttertoast.showToast(msg: '$errorMessage');
      //   })
      //  });
      //  }on FirebaseAuthException catch (error) {
      //     switch (error.code) {
      //       case "invalid-email":
      //         errorMessage = "Your email address appears to be malformed.";

      //         break;
      //       case "wrong-password":
      //         errorMessage = "Your password is wrong.";
      //         break;
      //       case "user-not-found":
      //         errorMessage = "User with this email doesn't exist.";
      //         break;
      //       case "user-disabled":
      //         errorMessage = "User with this email has been disabled.";
      //         break;
      //       case "too-many-requests":
      //         errorMessage = "Too many requests";
      //         break;
      //       case "operation-not-allowed":
      //         errorMessage = "Signing in with Email and Password is not enabled.";
      //         break;
      //       default:
      //         errorMessage = "An undefined Error happened.";
      //     }
      //     Fluttertoast.showToast(msg: '$errorMessage');
      //  }
    }
  }
}
