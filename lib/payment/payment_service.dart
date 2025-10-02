import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:quickshop/main.dart';

class PaymentService {
  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'amount': amount.toString(), 'currency': currency},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['client_secret'];
      } else {
        debugPrint("Stripe Error: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error creating PaymentIntent: $e");
      return null;
    }
  }

  /// Returns "success", "canceled", "incomplete" or "failed"
  Future<String> makePayment(int amount, String currency) async {
    try {
      final clientSecret = await createPaymentIntent(amount, currency);

      if (clientSecret == null) {
        return "failed"; // PaymentIntent not created
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Quickshop",
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return "success"; // Payment completed
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return "canceled"; //  User closed the sheet
      } else {
        return "incomplete"; //  Missing details or failed auth
      }
    } catch (e) {
      debugPrint("Payment Error: $e");
      return "failed";
    }
  }
}
