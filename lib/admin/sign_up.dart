import 'package:arunaapp/configure/constants.dart';
import 'package:arunaapp/admin/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/scheduler.dart';

class SignUpAdmin extends StatefulWidget {
  const SignUpAdmin({super.key});

  @override
  State<SignUpAdmin> createState() => _SignUpAdminState();
}

class _SignUpAdminState extends State<SignUpAdmin> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _userPasswordController1 = TextEditingController();
  final TextEditingController _userPasswordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.93,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    inputField(
                      controller: _usernameController,
                      label: "Nama Admin",
                      hint: "Nama Admin",
                      icon: Icons.badge_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Masukkan nama admin";
                        }
                        return null;
                      },
                    ),

                    inputField(
                      controller: _schoolController,
                      label: "Sekolah",
                      hint: "Masukkan nama sekolah",
                      icon: Icons.school_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Masukkan nama sekolah";
                        }
                        return null;
                      },
                    ),

                    inputField(
                      controller: _emailController,
                      label: "Email",
                      hint: "email@gmail.com",
                      icon: Icons.mail_outline_rounded,
                      validator: (value) {
                        if (!value!.contains('@')) {
                          return "Masukkan email yang valid";
                        }
                        return null;
                      },
                    ),

                    passwordField(
                      controller: _userPasswordController1,
                      label: "Kata Sandi",
                      visible: _passwordVisible1,
                      onTap: () {
                        setState(() {
                          _passwordVisible1 = !_passwordVisible1;
                        });
                      },
                      validator: (value) {
                        if (value!.length < 8) {
                          return "Password minimal 8 karakter";
                        }
                        return null;
                      },
                    ),

                    passwordField(
                      controller: _userPasswordController2,
                      label: "Konfirmasi Kata Sandi",
                      visible: _passwordVisible2,
                      onTap: () {
                        setState(() {
                          _passwordVisible2 = !_passwordVisible2;
                        });
                      },
                      validator: (value) {
                        if (value != _userPasswordController1.text) {
                          return "Password tidak sama";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 2.25,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            registerNewAdmin(context);
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(button),
                        ),
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: textbutton),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignInAdmin()),
                        );
                      },
                      child: Text(
                        'Sudah Punya Akun? Masuk',
                        style: TextStyle(color: textlogin),
                      ),
                    ),

                    Visibility(
                      visible: loading,
                      child: Container(
                        width: 250,
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: Colors.grey[700],
                          valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: textlogin),
        cursorColor: Colors.black,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconlogin),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colorlogin),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorlogin),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: label,
          labelStyle: TextStyle(color: textlogin),
          hintText: hint,
          hintStyle: TextStyle(color: textlogin),
        ),
      ),
    );
  }

  Widget passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required Function() onTap,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        validator: validator,
        style: TextStyle(color: textlogin),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline_rounded, color: iconlogin),
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: iconlogin,
            ),
            onPressed: onTap,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colorlogin),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorlogin),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: label,
          labelStyle: TextStyle(color: textlogin),
        ),
      ),
    );
  }

  Future<void> registerNewAdmin(BuildContext context) async {
    User? currentUser;

    try {
      currentUser = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _userPasswordController1.text.trim(),
      ))
          .user;

      if (currentUser != null) {
        await currentUser.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .set({
          'Nama Admin': _usernameController.text.trim(),
          'Sekolah': _schoolController.text.trim(),
          'Email': _emailController.text.trim(),
          'User UID': currentUser.uid,
          'Role': 'Admin',
          'Created_At': DateTime.now(),
        });

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SignInAdmin()));
        });

        Fluttertoast.showToast(msg: "Akun Admin berhasil dibuat");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal: $e");
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _schoolController.dispose();
    _userPasswordController1.dispose();
    _userPasswordController2.dispose();
    super.dispose();
  }
}
