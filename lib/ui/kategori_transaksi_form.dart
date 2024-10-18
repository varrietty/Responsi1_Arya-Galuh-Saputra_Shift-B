import 'package:flutter/material.dart';
import 'package:transac/bloc/kategori_transaksi_bloc.dart';
import 'package:transac/model/kategori_transaksi.dart';
import 'package:transac/ui/kategori_transaksi_page.dart';
import 'package:transac/widget/warning_dialog.dart';


// ignore: must_be_immutable
class KategoriTransaksiForm extends StatefulWidget {
  KategoriTransaksi? kategoriTransaksi;
  KategoriTransaksiForm({Key? key, this.kategoriTransaksi}) : super(key: key);
  @override
  _KategoriTransaksiFormState createState() => _KategoriTransaksiFormState();
}

class _KategoriTransaksiFormState extends State<KategoriTransaksiForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH KATEGORI TRANSAKSI";
  String tombolSubmit = "SIMPAN";
  final _transactionTextboxController = TextEditingController();
  final _typeTextboxController = TextEditingController();
  final _amountTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.kategoriTransaksi != null) {
      setState(() {
        judul = "UBAH KATEGORI TRANSAKSI";
        tombolSubmit = "UBAH";
        _transactionTextboxController.text = widget.kategoriTransaksi!.transaction!;
        _typeTextboxController.text = widget.kategoriTransaksi!.type!;
        _amountTextboxController.text = widget.kategoriTransaksi!.amount.toString();
      });
    } else {
      judul = "TAMBAH KATEGORI TRANSAKSI";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _transactionTextField(),
                _typeTextField(),
                _amountTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _transactionTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Transaction",
        labelStyle: TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      ),
      keyboardType: TextInputType.text,
      controller: _transactionTextboxController,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return "Transaction harus diisi";
        }
        return null;
      },
    );
  }

  Widget _typeTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Type",
        labelStyle: TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      ),
      keyboardType: TextInputType.text,
      controller: _typeTextboxController,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return "Type harus diisi";
        }
        return null;
      },
    );
  }

  Widget _amountTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Amount",
        labelStyle: TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      controller: _amountTextboxController,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return "Amount harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.green[800]),
        child: Text(
          tombolSubmit,
          style: const TextStyle(fontFamily: 'Times New Roman'),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.kategoriTransaksi != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        });
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });
    KategoriTransaksi createKategoriTransaksi = KategoriTransaksi(id: null);
    createKategoriTransaksi.transaction = _transactionTextboxController.text;
    createKategoriTransaksi.type = _typeTextboxController.text;
    createKategoriTransaksi.amount = int.parse(_amountTextboxController.text);

    KategoriTransaksiBloc.addKategoriTransaksi(kategoriTransaksi: createKategoriTransaksi).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const KategoriTransaksiPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });
    KategoriTransaksi updateKategoriTransaksi = KategoriTransaksi(id: widget.kategoriTransaksi!.id!);
    updateKategoriTransaksi.transaction = _transactionTextboxController.text;
    updateKategoriTransaksi.type = _typeTextboxController.text;
    updateKategoriTransaksi.amount = int.parse(_amountTextboxController.text);

    KategoriTransaksiBloc.updateKategoriTransaksi(kategoriTransaksi: updateKategoriTransaksi).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const KategoriTransaksiPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}