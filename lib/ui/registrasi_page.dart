import 'package:flutter/material.dart';
import '../bloc/registrasi_bloc.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          "Registrasi",
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              _buildRegistrationForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Form for Registration
  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _namaTextField(),
          const SizedBox(height: 20),
          _emailTextField(),
          const SizedBox(height: 20),
          _passwordTextField(),
          const SizedBox(height: 20),
          _passwordKonfirmasiTextField(),
          const SizedBox(height: 40),
          _buttonRegistrasi(),
        ],
      ),
    );
  }

  // Textbox for "Nama"
  Widget _namaTextField() {
    return TextFormField(
      controller: _namaTextboxController,
      style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      decoration: InputDecoration(
        labelText: "Nama",
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white70),
        filled: true,
        fillColor: Colors.green[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // Textbox for "Email"
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      decoration: InputDecoration(
        labelText: "Email",
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
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  // Textbox for "Password"
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white70),
        filled: true,
        fillColor: Colors.green[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // Textbox for "Konfirmasi Password"
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Konfirmasi Password",
        labelStyle: const TextStyle(fontFamily: 'Times New Roman', color: Colors.white70),
        filled: true,
        fillColor: Colors.green[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Button for "Registrasi"
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[900],
        textStyle: const TextStyle(fontFamily: 'Times New Roman'),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text("Registrasi"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }
}