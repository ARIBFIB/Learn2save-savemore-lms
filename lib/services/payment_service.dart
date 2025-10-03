import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';

class PaymentService {
  final String _baseUrl = ApiEndpoints.zohoCreatorBaseUrl;
  String? _authToken;

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Get available payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${ApiEndpoints.paymentMethods}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> methodsJson = data['payment_methods'] ?? [];
        return methodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment methods');
      }
    } catch (e) {
      throw Exception('Error fetching payment methods: ${e.toString()}');
    }
  }

  // Process payment for course enrollment
  Future<PaymentResult> processPayment({
    required String courseId,
    required String paymentMethodId,
    required double amount,
    required String currency,
  }) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.processPayment}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'course_id': courseId,
          'payment_method_id': paymentMethodId,
          'amount': amount,
          'currency': currency,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PaymentResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Payment failed');
      }
    } catch (e) {
      throw Exception('Payment processing error: ${e.toString()}');
    }
  }

  // Get subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${ApiEndpoints.subscriptionPlans}'),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> plansJson = data['subscription_plans'] ?? [];
        return plansJson.map((json) => SubscriptionPlan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subscription plans');
      }
    } catch (e) {
      throw Exception('Error fetching subscription plans: ${e.toString()}');
    }
  }

  // Get payment history
  Future<List<PaymentTransaction>> getPaymentHistory({int page = 1, int limit = 20}) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/payment/history?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> transactionsJson = data['transactions'] ?? [];
        return transactionsJson.map((json) => PaymentTransaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment history');
      }
    } catch (e) {
      throw Exception('Error fetching payment history: ${e.toString()}');
    }
  }

  // Add new payment method
  Future<PaymentMethod> addPaymentMethod({
    required String type,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardholderName,
    required String billingAddress,
  }) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payment/methods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'type': type,
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
          'cardholder_name': cardholderName,
          'billing_address': billingAddress,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PaymentMethod.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add payment method');
      }
    } catch (e) {
      throw Exception('Error adding payment method: ${e.toString()}');
    }
  }

  // Delete payment method
  Future<bool> deletePaymentMethod(String paymentMethodId) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/payment/methods/$paymentMethodId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting payment method: ${e.toString()}');
    }
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String expiryMonth;
  final String expiryYear;
  final String cardholderName;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardholderName,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      last4: json['last4'] ?? '',
      expiryMonth: json['expiry_month'] ?? '',
      expiryYear: json['expiry_year'] ?? '',
      cardholderName: json['cardholder_name'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cardholder_name': cardholderName,
      'is_default': isDefault,
    };
  }

  String get maskedNumber => '**** **** **** $last4';
  String get expiryDate => '$expiryMonth/$expiryYear';
}

class PaymentResult {
  final String id;
  final String status;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final String? transactionId;

  PaymentResult({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.transactionId,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'amount': amount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'transaction_id': transactionId,
    };
  }
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String billingCycle;
  final List<String> features;
  final bool isActive;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.billingCycle,
    this.features = const [],
    required this.isActive,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      billingCycle: json['billing_cycle'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'billing_cycle': billingCycle,
      'features': features,
      'is_active': isActive,
    };
  }
}

class PaymentTransaction {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? description;
  final String? courseId;
  final String? courseName;

  PaymentTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.description,
    this.courseId,
    this.courseName,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
      courseId: json['course_id'],
      courseName: json['course_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'description': description,
      'course_id': courseId,
      'course_name': courseName,
    };
  }
}