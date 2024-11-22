import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/currency_service.dart';
import '../utils/constants.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String baseCurrency = 'USD';
  String targetCurrency = 'EUR';
  double amount = 1.0;
  double convertedAmount = 0.0;
  String errorMessage = '';

  final TextEditingController _amountController = TextEditingController();
  final CurrencyService _currencyService = CurrencyService();

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  void _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      baseCurrency = prefs.getString('baseCurrency') ?? 'USD';
      targetCurrency = prefs.getString('targetCurrency') ?? 'EUR';
      amount = prefs.getDouble('amount') ?? 1.0;
      _amountController.text = amount.toString();
    });
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseCurrency', baseCurrency);
    await prefs.setString('targetCurrency', targetCurrency);
    await prefs.setDouble('amount', amount);
  }

  Future<void> _convertCurrency() async {
    try {
      final result = await _currencyService.convertCurrency(
        baseCurrency,
        targetCurrency,
        amount,
      );

      setState(() {
        convertedAmount = result;
        errorMessage = '';
      });

      _savePreferences();
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = baseCurrency;
      baseCurrency = targetCurrency;
      targetCurrency = temp;
      _amountController.text = amount.toString();
      _convertCurrency();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Currency Converter',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: const Color(0xFF333333),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 252, 252, 252), Color.fromARGB(255, 238, 178, 245)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    labelStyle: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 12, 12, 12).withOpacity(0.8),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 25,
                    color: const Color.fromARGB(255, 9, 9, 9),
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 1.0;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildCurrencyDropdown(
                      value: baseCurrency,
                      label: 'From',
                      onChanged: (value) {
                        setState(() {
                          baseCurrency = value!;
                        });
                        _convertCurrency();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.swap_horiz,
                      size: 32,
                      color: Color.fromARGB(255, 113, 175, 157),
                    ),
                    onPressed: _swapCurrencies,
                  ),
                  Expanded(
                    child: _buildCurrencyDropdown(
                      value: targetCurrency,
                      label: 'To',
                      onChanged: (value) {
                        setState(() {
                          targetCurrency = value!;
                        });
                        _convertCurrency();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 37, 37),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  'Convert Now',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: GoogleFonts.nunitoSans(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 228, 246),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Converted Amount',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 84, 2, 84),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${convertedAmount.toStringAsFixed(2)} $targetCurrency',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                      
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required String label,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.nunitoSans(fontSize: 14),
          border: InputBorder.none,
        ),
        items: AppConstants.currencies.map((currency) {
          return DropdownMenuItem(
            value: currency,
            child: Text(
              currency,
              style: GoogleFonts.nunitoSans(fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
