import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stunting_android/screens/detail_page.dart';
import 'package:stunting_android/services/api_service.dart';

class AnalyzerPage extends StatefulWidget {
  const AnalyzerPage({Key? key}) : super(key: key);

  @override
  _AnalyzerPageState createState() => _AnalyzerPageState();
}

class _AnalyzerPageState extends State<AnalyzerPage> {
  final TextEditingController _namaBayiController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _tinggiBadanController = TextEditingController();
  String? _selectedGender;
  final ApiService _apiService = ApiService();
  String? _errorMessage;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final historyData = await _apiService.getKalkulatorFuzzy();
      setState(() {
        _history = List<Map<String, dynamic>>.from(historyData['data'] ?? []);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan riwayat kalkulator: $e';
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final usia = int.tryParse(_usiaController.text);
      final tinggiBadan = double.tryParse(_tinggiBadanController.text);

      if (_namaBayiController.text.isEmpty ||
          _selectedGender == null ||
          usia == null ||
          usia < 0 ||
          usia > 60 ||
          double.tryParse(_beratBadanController.text) == null ||
          tinggiBadan == null ||
          tinggiBadan < 45 ||
          tinggiBadan > 120) {
        setState(() {
          _errorMessage = 'Isi semua field dengan benar.';
        });
        return;
      }

      final result = await _apiService.createKalkulatorFuzzy(
        _namaBayiController.text,
        _selectedGender!,
        usia,
        double.parse(_beratBadanController.text),
        tinggiBadan,
      );
      print("Calculation successful: $result");

      await _fetchHistory();

      _namaBayiController.clear();
      _usiaController.clear();
      _beratBadanController.clear();
      _tinggiBadanController.clear();
      _selectedGender = null;

      if (_history.isNotEmpty) {
        final lastHistoryItem = _history.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(historyItem: lastHistoryItem),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Stunting'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _namaBayiController,
              hintText: 'Nama Bayi',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              value: _selectedGender,
              items: const ['Laki-Laki', 'Perempuan'],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              hintText: 'Jenis Kelamin',
              prefixIcon: Icons.wc,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _usiaController,
              hintText: 'Usia (bulan)',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              prefixIcon: Icons.cake,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _beratBadanController,
              hintText: 'Berat Badan (kg)',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              prefixIcon: Icons.monitor_weight,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _tinggiBadanController,
              hintText: 'Tinggi Badan (cm)',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                LengthLimitingTextInputFormatter(5),
              ],
              prefixIcon: Icons.height,
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            _buildButton(
              onPressed: _submitForm,
              text: 'Hitung Resiko Stunting',
            ),
            const SizedBox(height: 24),
            const Text(
              'Riwayat Kalkulator Stunting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_history.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final historyItem = _history[index];
                  return _buildHistoryCard(historyItem);
                },
              )
            else
              const Text('Tidak ada riwayat tersedia'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> historyItem) {
    final nama = historyItem['nama_bayi'] ?? 'Nama tidak tersedia';
    final gender =
        historyItem['jenis_kelamin'] ?? 'Jenis kelamin tidak tersedia';
    final usia = historyItem['usia']?.toString() ?? 'Usia tidak tersedia';
    final beratBadan =
        historyItem['berat_badan']?.toString() ?? 'Berat badan tidak tersedia';
    final tinggiBadan = historyItem['tinggi_badan']?.toString() ??
        'Tinggi badan tidak tersedia';
    final hasil = historyItem['index_fuzzy']['nama']?.toString() ??
        'Riwayat tidak tersedia';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(historyItem: historyItem),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Jenis Kelamin: $gender'),
                    const SizedBox(height: 4),
                    Text('Usia: $usia bulan'),
                    const SizedBox(height: 4),
                    Text('Berat Badan: $beratBadan kg'),
                    const SizedBox(height: 4),
                    Text('Tinggi Badan: $tinggiBadan cm'),
                    const SizedBox(height: 4),
                    Text('Hasil Fuzzy: $hasil'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
