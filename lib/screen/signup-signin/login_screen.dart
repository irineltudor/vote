import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote/screen/navigator/navigator_screen.dart';
import 'package:vote/screen/signup-signin/registration_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:vote/widget/code_dialog_widget.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // string for displaying the error
  String? errorMessage;

  bool isLoggedIn = true;

  bool passVisibility = false;

  late SharedPreferences prefs;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
  }

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
          return ("Please enter a valid email");
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

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      style: theme.textTheme.titleMedium
          ?.copyWith(color: theme.scaffoldBackgroundColor),
      controller: passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key, color: theme.scaffoldBackgroundColor),
        hintStyle: theme.textTheme.titleMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        errorStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.scaffoldBackgroundColor.withOpacity(0.75)),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor)),
      ),
    );

    final loginButton = Material(
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
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium
              ?.copyWith(color: theme.scaffoldBackgroundColor),
        ),
      ),
    );

    emailController.text = "tirynel@yahoo.com";
    passwordController.text = "12345678";

    // if (isLoggedIn) {
    //   return Scaffold(
    //     body: Container(
    //         color: Colors.black,
    //         child: const Center(
    //             child: CircularProgressIndicator(
    //           color: Colors.white,
    //         ))),
    //   );
    // }

    return Scaffold(
        body: Stack(
      children: [
        Container(color: theme.primaryColor),
        Center(
            child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
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
                      child:
                          //  Image.asset(
                          //   isDarkMode
                          //       ? "assets/logo/dark/logo.png"
                          //       : "assets/logo/light/logo.png",
                          //   fit: BoxFit.contain,
                          // ),
                          LottieBuilder.asset(isDarkMode
                              ? "assets/logo/dark/logo_animation.json"
                              : "assets/logo/light/logo_animation.json"),
                    ),
                    Column(
                      children: [
                        Text('Welcome Back,',
                            style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.scaffoldBackgroundColor)),
                        Text('Sign in to your account',
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor)),
                      ],
                    ),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: Text(
                            "Forgot password?",
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.scaffoldBackgroundColor),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account? ",
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.scaffoldBackgroundColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: theme.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1))
                                ],
                                border: Border.all(
                                    color: theme.scaffoldBackgroundColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                )),
                            child: Text(
                              "Create",
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ],
    ));
  }

  // login function
  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) async => {
                  prefs = await SharedPreferences.getInstance(),
                  prefs.setString("email", email),
                  prefs.setString("password", password),
                  if (mounted)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        content: Text("Login Successful"),
                        backgroundColor: Colors.green,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                      )),
                      // await getTickets(uid.user!.uid),
                      //Fluttertoast.showToast(msg: "Login Successful"),
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const NavigatorScreen())),
                    }
                });
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
                await e.resolver.resolveSignIn(
                  PhoneMultiFactorGenerator.getAssertion(
                    credential,
                  ),
                );
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const NavigatorScreen()));
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
            errorMessage = "Your email or password are invalid.";
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
                errorMessage!,
              ),
              backgroundColor: Colors.red,
              closeIconColor: Colors.white,
              showCloseIcon: true,
            ),
          );
        }
      }
    }
  }
}
