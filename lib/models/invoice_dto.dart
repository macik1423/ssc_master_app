import 'package:json_annotation/json_annotation.dart';

part 'invoice_dto.g.dart';

@JsonSerializable()
class InvoiceDto {
  final String invoiceNumber;
  final String contractorName;

  InvoiceDto({
    required this.invoiceNumber,
    required this.contractorName,
  });

  Map<String, dynamic> toJson() => _$InvoiceDtoToJson(this);
}
