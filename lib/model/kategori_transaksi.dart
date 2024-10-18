class KategoriTransaksi {
  int? id;
  String? transaction;
  String? type;
  int? amount;

  KategoriTransaksi({this.id, this.transaction, this.type, this.amount});

  factory KategoriTransaksi.fromJson(Map<String, dynamic> obj) {
    return KategoriTransaksi(
      id: obj['id'],
      transaction: obj['transaction'],
      type: obj['type'],
      amount: obj['amount'],
    );
  }
}