// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDto _$InvoiceDtoFromJson(Map<String, dynamic> json) => InvoiceDto(
      invoiceNumber: json['invoiceNumber'] as String,
      contractorName: json['contractorName'] as String,
    );

Map<String, dynamic> _$InvoiceDtoToJson(InvoiceDto instance) =>
    <String, dynamic>{
      'invoiceNumber': instance.invoiceNumber,
      'contractorName': instance.contractorName,
    };
