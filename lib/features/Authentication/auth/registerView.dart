import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:musicapp/features/home/homeview.dart';
import 'package:musicapp/features/widgets/customAlertDialogMethod.dart';
import 'package:musicapp/utilits/assets.dart';
import 'package:musicapp/utilits/constants/constant.dart';
import 'package:musicapp/utilits/constants/fontsStyles.dart';
import 'package:musicapp/utilits/constants/validateAuth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const routName = '/RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
        });
        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) {
          return;
        }
        GoRouter.of(context).push("/loginScreen");
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
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: FontsStyles.teststyle28
                      .copyWith(fontWeight: FontWeight.w800),
                ),
                const Gutter(),
                const Text(
                  "Sign up to Create happiness with your contributions.",
                  style: FontsStyles.teststyle15,
                ),
                const GutterLarge(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: "Full name",
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        validator: (value) {
                          return AuthValidator.displayNamevalidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email address",
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          return AuthValidator.emailValidator(value);
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "*********",
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
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "*********",
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
                          return AuthValidator.repeatPasswordValidator(
                              value: value, password: _passwordController.text);
                        },
                        onFieldSubmitted: (value) {
                          _registerFct();
                        },
                      ),
                      const Gutter(),
                      TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                          ),
                          onPressed: () {
                            _registerFct();
                          },
                          child: const Text(
                            "Sign Up",
                            style: FontsStyles.teststyle17,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
