import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:musicapp/features/Authentication/auth/forgot_password.dart';
import 'package:musicapp/features/Authentication/auth/registerView.dart';
import 'package:musicapp/features/home/homeview.dart';
import 'package:musicapp/features/widgets/customAlertDialogMethod.dart';
import 'package:musicapp/utilits/assets.dart';
import 'package:musicapp/utilits/constants/constant.dart';
import 'package:musicapp/utilits/constants/fontsStyles.dart';
import 'package:musicapp/utilits/constants/validateAuth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routName = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Focus Nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) {
          return;
        }
        GoRouter.of(context).push("/HomeScreen");
      } on FirebaseAuthException catch (error) {
        await CustomAlertDialoge.showErrorORWarningDialog(
          context: context,
          errMessage: "An error has been occured ${error.message}",
          fn: () {},
          image: 'assets/images/persons/sad_person.png',
        );
      } catch (error) {
        await CustomAlertDialoge.showErrorORWarningDialog(
          context: context,
          errMessage: "An error has been occured $error",
          fn: () {},
          image: 'assets/images/persons/sad_person.png',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Image.asset(
              AssetsConstant.Splashlogo,
              height: 50,
            ),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const GutterLarge(),
                    const GutterLarge(),
                    Center(
                      child: Text(
                        "Welcome",
                        style: FontsStyles.teststyle28
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Gutter(),
                    const Text(
                      "Please enter your data to continue",
                      style: FontsStyles.teststyle15,
                    ),
                    const GutterLarge(),
                    const GutterLarge(),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email address",
                        labelText: "Email address",
                      ),
                      validator: (value) {
                        return AuthValidator.emailValidator(value);
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    const Gutter(),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "*********",
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        return AuthValidator.passwordValidator(value);
                      },
                      onFieldSubmitted: (value) {
                        _loginFct();
                      },
                    ),
                    const Gutter(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push("/ForgotPasswordScreen");
                        },
                        child: Text(
                          "Forget Password?",
                          style: FontsStyles.teststyle15
                              .copyWith(color: Colors.red),
                        ),
                      ),
                    ),
                    const GutterLarge(),
                    TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        onPressed: () {
                          _loginFct();
                        },
                        child: const Text(
                          "Sign In",
                          style: FontsStyles.teststyle17,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't Hava Account ",
                        ),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push("/RegisterScreen");
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
