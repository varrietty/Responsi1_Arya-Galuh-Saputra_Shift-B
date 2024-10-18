import 'dart:convert';
import 'package:transac/helpers/api.dart';
import 'package:transac/helpers/api_url.dart';
import 'package:transac/model/kategori_transaksi.dart';

class KategoriTransaksiBloc {
  // Mengambil daftar kategori transaksi
  static Future<List<KategoriTransaksi>> getKategoriTransaksi() async {
    String apiUrl = ApiUrl.listKategori;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listKategori = (jsonObj as Map<String, dynamic>)['data'];
    List<KategoriTransaksi> kategoriTransaksis = [];
    
    for (int i = 0; i < listKategori.length; i++) {
      kategoriTransaksis.add(KategoriTransaksi.fromJson(listKategori[i]));
    }
    
    return kategoriTransaksis;
  }

  // Menambahkan kategori transaksi baru
  static Future<bool> addKategoriTransaksi({required KategoriTransaksi kategoriTransaksi}) async {
    String apiUrl = ApiUrl.createKategori;

    var body = {
      "transaction": kategoriTransaksi.transaction,
      "type": kategoriTransaksi.type,
      "amount": kategoriTransaksi.amount // Jangan gunakan toString()
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Memperbarui kategori transaksi yang ada
  static Future<bool> updateKategoriTransaksi({required KategoriTransaksi kategoriTransaksi}) async {
    String apiUrl = ApiUrl.updateKategori(kategoriTransaksi.id!);
    print(apiUrl);

    var body = {
      "transaction": kategoriTransaksi.transaction,
      "type": kategoriTransaksi.type,
      "amount": kategoriTransaksi.amount // Pastikan ini integer
    };
    print("Body : $body");
    
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // Menghapus kategori transaksi berdasarkan ID
  static Future<bool> deleteKategoriTransaksi({required int id}) async {
    String apiUrl = ApiUrl.deleteKategori(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}