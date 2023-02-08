import 'package:json_annotation/json_annotation.dart';

part 'invoice_dto.g.dart';

@JsonSerializable()
class InvoiceDto {
  final String invoiceNumber;
  final String contractorName;
  final int netWorth;

  InvoiceDto({
    required this.invoiceNumber,
    required this.contractorName,
    required this.netWorth,
  });

  Map<String, dynamic> toJson() => _$InvoiceDtoToJson(this);

  factory InvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDtoFromJson(json);
}
