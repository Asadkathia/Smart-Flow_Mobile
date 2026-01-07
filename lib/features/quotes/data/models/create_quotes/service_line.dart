import 'service_item.dart';

// Service line model
class ServiceLine {
  final ServiceItem service;
  final int quantity;

  ServiceLine({required this.service, required this.quantity});

  double get total => service.pricePerUnit * quantity;

  ServiceLine copyWith({ServiceItem? service, int? quantity}) =>
      ServiceLine(service: service ?? this.service, quantity: quantity ?? this.quantity);
}

