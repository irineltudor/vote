import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }

        //reg ex for email valid
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please eneter a valid email");
        }

        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
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

    final resetPasswordButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: theme.primaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: theme.scaffoldBackgroundColor)),
        minWidth: MediaQuery.of(context).size.width / 1.5,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              await _auth.sendPasswordResetEmail(email: emailController.text);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Email sent"),
                backgroundColor: Colors.green,
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ));
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            } on FirebaseAuthException catch (error) {
              switch (error.code) {
                case "user-not-found":
                  errorMessage = "Email not found";
                  break;
              }

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errorMessage!,
                  ),
                  backgroundColor: Colors.red,
                  closeIconColor: Colors.white,
                  showCloseIcon: true,
                ),
              );
            }
          }
        },
        child: Text(
          "Reset Password",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium
              ?.copyWith(color: theme.scaffoldBackgroundColor),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          // title: const Text('Reset Password',
          //    style: TextStyle(color: Colors.white)),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        isDarkMode
                            ? "assets/logo/dark/logo.png"
                            : "assets/logo/light/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(
                      children: [
                        Text('Reset Password,',
                            style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor)),
                        const SizedBox(height: 5),
                        Text('Type in your email address',
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    emailField,
                    const SizedBox(height: 25),
                    resetPasswordButton,
                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
