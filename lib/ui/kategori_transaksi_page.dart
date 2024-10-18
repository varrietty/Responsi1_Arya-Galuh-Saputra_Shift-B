import 'package:flutter/material.dart';
import 'package:transac/bloc/kategori_transaksi_bloc.dart';
import 'package:transac/model/kategori_transaksi.dart';
import 'package:transac/ui/kategori_transaksi_detail.dart';
import 'package:transac/ui/kategori_transaksi_form.dart';

class KategoriTransaksiPage extends StatefulWidget {
  const KategoriTransaksiPage({Key? key}) : super(key: key);

  @override
  _KategoriTransaksiPageState createState() => _KategoriTransaksiPageState();
}

class _KategoriTransaksiPageState extends State<KategoriTransaksiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          "Kategori Transaksi",
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[900],
      ),
      body: FutureBuilder<List<KategoriTransaksi>>(
        future: KategoriTransaksiBloc.getKategoriTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error: Gagal mengambil data",
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Colors.red,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return _buildListView(snapshot.data!);
          } else {
            return const Center(
              child: Text(
                "Tidak ada data",
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Colors.white70,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KategoriTransaksiForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<KategoriTransaksi> kategoriTransaksiList) {
    return ListView.builder(
      itemCount: kategoriTransaksiList.length,
      itemBuilder: (context, index) {
        KategoriTransaksi kategoriTransaksi = kategoriTransaksiList[index];
        return Card(
          color: Colors.green[800],
          child: ListTile(
            title: Text(
              kategoriTransaksi.transaction!,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Type: ${kategoriTransaksi.type} - Amount: Rp. ${kategoriTransaksi.amount}",
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.white70,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(kategoriTransaksi),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KategoriTransaksiDetail(kategoriTransaksi: kategoriTransaksi),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(KategoriTransaksi kategoriTransaksi) {
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
            KategoriTransaksiBloc.deleteKategoriTransaksi(id: kategoriTransaksi.id!).then((value) {
              Navigator.of(context).pop();
              setState(() {});
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

    showDialog(context: context, builder: (context) => alertDialog);
  }
}