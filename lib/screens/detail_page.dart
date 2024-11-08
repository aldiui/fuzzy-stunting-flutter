import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> historyItem;

  const DetailPage({Key? key, required this.historyItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(historyItem['weight_average']);
    final nama = historyItem['nama_bayi'] ?? 'Nama tidak tersedia';
    final gender =
        historyItem['jenis_kelamin'] ?? 'Jenis kelamin tidak tersedia';
    final usia = historyItem['usia']?.toString() ?? 'Usia tidak tersedia';
    final beratBadan =
        historyItem['berat_badan']?.toString() ?? 'Berat badan tidak tersedia';
    final tinggiBadan = historyItem['tinggi_badan']?.toString() ??
        'Tinggi badan tidak tersedia';
    final zScoreBbu =
        historyItem['z_score_bbu']?.toString() ?? 'Z-Score BBU tidak tersedia';
    final zScoreTbu =
        historyItem['z_score_tbu']?.toString() ?? 'Z-Score TBU tidak tersedia';
    final zScoreBbtb = historyItem['z_score_bbtb']?.toString() ??
        'Z-Score BBTB tidak tersedia';
    final hasil = historyItem['index_fuzzy']['nama']?.toString() ??
        'Hasil tidak tersedia';
    final weightAverage =
        historyItem['kondisi_anak']['weight_average']?.toString() ??
            'Tidak tersedia';
    final kesimpulan = historyItem['kesimpulan'] ?? 'Tidak tersedia';

    final List<Map<String, dynamic>> rules = List<Map<String, dynamic>>.from(
        historyItem['kondisi_anak']['rules'] ?? []);
    final fuzzyBbu =
        List<Map<String, dynamic>>.from(historyItem['fuzzy_bbu'] ?? []);
    final fuzzyTbu =
        List<Map<String, dynamic>>.from(historyItem['fuzzy_tbu'] ?? []);
    final fuzzyBbtb =
        List<Map<String, dynamic>>.from(historyItem['fuzzy_bbtb'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat Stunting'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Nama Bayi', nama),
                    _buildDetailRow('Jenis Kelamin', gender),
                    _buildDetailRow('Usia (bulan)', usia),
                    _buildDetailRow('Berat Badan (kg)', beratBadan),
                    _buildDetailRow('Tinggi Badan (cm)', tinggiBadan),
                    _buildDetailRow('Z-Score BBU', zScoreBbu),
                    _buildDetailRow('Z-Score TBU', zScoreTbu),
                    _buildDetailRow('Z-Score BBTB', zScoreBbtb),
                    _buildDetailRow('Hasil Fuzzy', hasil),
                    _buildDetailRow('Weight Average', weightAverage),
                    _buildKesimpulan(kesimpulan),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFuzzyVariableTable('BBU', fuzzyBbu),
            const SizedBox(height: 20),
            _buildFuzzyVariableTable('TBU', fuzzyTbu),
            const SizedBox(height: 20),
            _buildFuzzyVariableTable('BBTB', fuzzyBbtb),
            const SizedBox(height: 20),
            _buildRulesTable(rules),
          ],
        ),
      ),
    );
  }

  Widget _buildKesimpulan(String kesimpulan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kesimpulan:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            kesimpulan,
            style: const TextStyle(fontSize: 16),
            softWrap: true,
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesTable(List<Map<String, dynamic>> rules) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kondisi Anak (Rules)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FractionColumnWidth(0.2),
                1: FractionColumnWidth(0.4),
                2: FractionColumnWidth(0.4),
              },
              children: [
                _buildTableHeaderRow(),
                for (var rule in rules) _buildTableDataRow(rule),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableCell('Rule', isHeader: true),
        _buildTableCell('Nama', isHeader: true),
        _buildTableCell('Defuzifikasi', isHeader: true),
      ],
    );
  }

  TableRow _buildTableDataRow(Map<String, dynamic> rule) {
    final id = rule['id'].toString();
    final kriteria = rule['index_fuzzy']['nama'].toString();
    final interval = rule['index_fuzzy']['range_akhir'].toString();

    return TableRow(
      children: [
        _buildTableCell(id),
        _buildTableCell(kriteria),
        _buildTableCell(interval),
      ],
    );
  }

  Widget _buildTableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFuzzyVariableTable(
      String title, List<Map<String, dynamic>> fuzzyVariables) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title Fuzzy Variable',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FractionColumnWidth(0.4),
                1: FractionColumnWidth(0.3),
                2: FractionColumnWidth(0.3),
              },
              children: [
                _buildFuzzyTableHeaderRow(),
                for (var fuzzy in fuzzyVariables)
                  _buildFuzzyTableDataRow(fuzzy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildFuzzyTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableCell('Nilai Linguistik', isHeader: true),
        _buildTableCell('Fuzzy Value', isHeader: true),
        _buildTableCell('Interval', isHeader: true),
      ],
    );
  }

  TableRow _buildFuzzyTableDataRow(Map<String, dynamic> fuzzy) {
    final status = fuzzy['status'] ?? 'Tidak tersedia';
    final interval = fuzzy['interval']?.join(', ') ?? 'Tidak tersedia';
    final fuzzyValue =
        fuzzy['fuzzy'] != null ? fuzzy['fuzzy'].toString() : 'Tidak tersedia';

    return TableRow(
      children: [
        _buildTableCell(status),
        _buildTableCell(fuzzyValue),
        _buildTableCell(interval),
      ],
    );
  }
}
