import 'package:arunaapp/admin/sign_in.dart';
import 'package:arunaapp/configure/constants.dart';
import 'package:arunaapp/menu_user/home/index.dart';
import 'package:arunaapp/user/auth_service.dart';
import 'package:arunaapp/user/reset_password.dart';
import 'package:arunaapp/user/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.93,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // EMAIL FIELD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            style: TextStyle(color: textlogin),
                            cursorColor: Colors.black,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline_rounded, color: iconlogin),
                              hintText: 'email@gmail.com',
                              hintStyle: TextStyle(fontWeight: FontWeight.bold, color: textlogin),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelStyle: TextStyle(color: textlogin),
                              labelText: "Email",
                            ),
                          ),
                        ),

                        // PASSWORD FIELD
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            style: TextStyle(color: textlogin),
                            cursorColor: Colors.black,
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline_rounded, color: iconlogin),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: "Kata Sandi",
                              labelStyle: TextStyle(color: textlogin),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                  color: iconlogin,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        // LUPA PASSWORD
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => ResetPassword()));
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Lupa Kata Sandi', style: TextStyle(color: iconlogin)),
                          ),
                        ),

                        // LOGIN BUTTON
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: ElevatedButton(
                            onPressed: loginUser,
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(button),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textbutton),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10.0),

                        // SIGN UP
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => SignUp()),
                            );
                          },
                          child: Text('Belum Memiliki Akun? Daftar', style: TextStyle(color: textlogin)),
                        ),

                        // LOGIN ADMIN
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => SignInAdmin()),
                            );
                          },
                          child: Text('Login sebagai Admin', style: TextStyle(color: textlogin)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    _saveCredentials();

    final message = await AuthService().login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (message!.contains('Sukses')) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        String firstName = snap["firstName"] ?? "User";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(firstName: firstName),
          ),
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }
}
