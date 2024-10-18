class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';

  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listKategori = baseUrl + 'api/keuangan/kategori_transaksi';
  static const String createKategori = baseUrl + 'api/keuangan/kategori_transaksi';

  static String updateKategori(int id) {
    return baseUrl + 'api/keuangan/kategori_transaksi/' + id.toString() + '/update';
  }

  static String showKategori(int id) {
    return baseUrl + 'api/keuangan/kategori_transaksi/' + id.toString();
  }

  static String deleteKategori(int id) {
    return baseUrl + 'api/keuangan/kategori_transaksi/' + id.toString() + '/delete';
  }
}