import 'package:flutter/material.dart';
import 'package:transac/bloc/kategori_transaksi_bloc.dart';
import 'package:transac/model/kategori_transaksi.dart';
import 'package:transac/ui/kategori_transaksi_form.dart';
import 'package:transac/ui/kategori_transaksi_page.dart';
import 'package:transac/widget/warning_dialog.dart';

// ignore: must_be_immutable
class KategoriTransaksiDetail extends StatefulWidget {
  KategoriTransaksi? kategoriTransaksi;

  KategoriTransaksiDetail({Key? key, this.kategoriTransaksi}) : super(key: key);

  @override
  _KategoriTransaksiDetailState createState() => _KategoriTransaksiDetailState();
}

class _KategoriTransaksiDetailState extends State<KategoriTransaksiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Detail Kategori Transaksi',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Transaction: ${widget.kategoriTransaksi!.transaction}",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'Times New Roman',
                color: Colors.white,
              ),
            ),
            Text(
              "Type: ${widget.kategoriTransaksi!.type}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Times New Roman',
                color: Colors.white70,
              ),
            ),
            Text(
              "Amount: Rp. ${widget.kategoriTransaksi!.amount}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Times New Roman',
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.green[800]),
          child: const Text("EDIT", style: TextStyle(fontFamily: 'Times New Roman')),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KategoriTransaksiForm(
                  kategoriTransaksi: widget.kategoriTransaksi!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red[800]),
          child: const Text("DELETE", style: TextStyle(fontFamily: 'Times New Roman')),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.black87,
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(fontFamily: 'Times New Roman', color: Colors.white),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.green[800]),
          child: const Text("Ya", style: TextStyle(fontFamily: 'Times New Roman')),
          onPressed: () {
            KategoriTransaksiBloc.deleteKategoriTransaksi(id: widget.kategoriTransaksi!.id!).then(
                (value) => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const KategoriTransaksiPage()))
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red[800]),
          child: const Text("Batal", style: TextStyle(fontFamily: 'Times New Roman')),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}