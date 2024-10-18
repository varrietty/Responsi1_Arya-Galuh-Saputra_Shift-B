import 'package:flutter/material.dart';
import 'package:transac/bloc/login_bloc.dart';
import 'package:transac/helpers/user_info.dart';
import 'package:transac/ui/registrasi_page.dart';
import 'package:transac/ui/kategori_transaksi_page.dart';
// ignore: unused_import
import 'package:transac/widget/success_dialog.dart';
import 'package:transac/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 50),
                  _emailTextField(),
                  const SizedBox(height: 20),
                  _passwordTextField(),
                  const SizedBox(height: 40),
                  _buttonLogin(),
                  const SizedBox(height: 20),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat latar belakang gelap hijau
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[900]!, Colors.green[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // Header Login
  Widget _buildAppBar() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Times New Roman',
      ),
    );
  }

  // Membuat TextField untuk email
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white70),
        filled: true,
        fillColor: Colors.green[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat TextField untuk password
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white70),
        filled: true,
        fillColor: Colors.green[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  // Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[900], // Warna background hijau gelap
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontFamily: 'Times New Roman'),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text('Login'),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate && !_isLoading) {
          _submit();
        }
      },
    );
  }

  void _submit() {
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token!);
        await UserInfo().setUserID(value.userID!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const KategoriTransaksiPage()),
        );
      } else {
        _showWarningDialog('Login gagal, silahkan coba lagi');
      }
    }).catchError((error) {
      _showWarningDialog('Login gagal, silahkan coba lagi');
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Fungsi untuk menampilkan dialog peringatan
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WarningDialog(description: message),
    );
  }

  // Menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          'Registrasi',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}