import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class CurrencyService {
  Future<double> convertCurrency(
    String baseCurrency, 
    String targetCurrency, 
    double amount
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['conversion_rates'];
        return amount * rates[targetCurrency];
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}