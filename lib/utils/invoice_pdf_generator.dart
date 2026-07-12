import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_models.dart';
import 'package:taxi_for_you/utils/currency_display.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class InvoicePdfGenerator {
  InvoicePdfGenerator._();

  static const PdfColor _navy = PdfColor.fromInt(0xFF080957);
  static const PdfColor _muted = PdfColor.fromInt(0xFFA4A4AD);
  static const PdfColor _metaBg = PdfColor.fromInt(0xFFEFEFFE);
  static const PdfColor _line = PdfColor.fromInt(0xFFE1E1E4);
  static const PdfColor _totalBg = PdfColor.fromInt(0xFFF4F4FA);

  static pw.Font? _latoRegular;
  static pw.Font? _latoBold;
  static pw.Font? _cairoRegular;
  static pw.Font? _cairoBold;
  static pw.Font? _riyalRegular;
  static pw.Font? _riyalBold;

  static Future<Uint8List> generate(TripInvoice invoice) async {
    await _ensureFonts();
    final logoBytes = await rootBundle.load(ImageAssets.splashIc);
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final dateLabel = _formatDate(invoice.completionDate ?? invoice.creationDate);
    final regularLines =
        invoice.lines.where((line) => !line.totalLine).toList();
    InvoiceLine? totalLine;
    for (final line in invoice.lines) {
      if (line.totalLine) {
        totalLine = line;
        break;
      }
    }

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _brandHeader(logo),
              pw.SizedBox(height: 18),
              _titleSection(invoice),
              pw.SizedBox(height: 14),
              _metaSection(invoice, dateLabel),
              pw.SizedBox(height: 16),
              pw.Divider(color: _line, thickness: 1),
              pw.SizedBox(height: 12),
              for (var i = 0; i < regularLines.length; i++) ...[
                _lineItem(regularLines[i], invoice.currencyCode),
                if (i < regularLines.length - 1) ...[
                  pw.SizedBox(height: 10),
                  pw.Divider(color: _line, thickness: 0.8),
                  pw.SizedBox(height: 10),
                ],
              ],
              if (totalLine != null) ...[
                pw.SizedBox(height: 14),
                _dashedSeparator(),
                pw.SizedBox(height: 10),
                _totalSection(totalLine, invoice.currencyCode),
              ],
              pw.Spacer(),
              _footer(),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static Future<void> _ensureFonts() async {
    if (_latoRegular != null) return;

    final latoRegularData =
        await rootBundle.load('assets/fonts/english/Lato-Regular.ttf');
    final latoBoldData =
        await rootBundle.load('assets/fonts/english/Lato-Bold.ttf');
    final cairoRegularData =
        await rootBundle.load('assets/fonts/arabic/Cairo-Regular.ttf');
    final cairoBoldData =
        await rootBundle.load('assets/fonts/arabic/Cairo-Bold.ttf');
    final riyalRegularData =
        await rootBundle.load('assets/fonts/saudi_riyal/saudi_riyal.ttf');
    final riyalBoldData =
        await rootBundle.load('assets/fonts/saudi_riyal/saudi_riyal_bold.ttf');

    _latoRegular = pw.Font.ttf(latoRegularData);
    _latoBold = pw.Font.ttf(latoBoldData);
    _cairoRegular = pw.Font.ttf(cairoRegularData);
    _cairoBold = pw.Font.ttf(cairoBoldData);
    _riyalRegular = pw.Font.ttf(riyalRegularData);
    _riyalBold = pw.Font.ttf(riyalBoldData);
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final timestamp = int.tryParse(raw);
    if (timestamp == null) return '';
    return DateFormat('dd MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  static pw.Widget _brandHeader(pw.MemoryImage logo) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 20),
      decoration: pw.BoxDecoration(
        color: _navy,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Column(
        children: [
          pw.Image(logo, width: 130, height: 48, fit: pw.BoxFit.contain),
          pw.SizedBox(height: 8),
          pw.Text(
            AppStrings.twselaCaptian.tr(),
            style: pw.TextStyle(
              font: _latoBold,
              fontSize: 12,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _titleSection(TripInvoice invoice) {
    return pw.Column(
      children: [
        pw.Text(
          invoice.titleEn,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: _latoBold, fontSize: 16, color: _navy),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          invoice.titleAr,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: _cairoBold, fontSize: 16, color: _navy),
        ),
      ],
    );
  }

  static pw.Widget _metaSection(TripInvoice invoice, String dateLabel) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: pw.BoxDecoration(
        color: _metaBg,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _line),
      ),
      child: pw.Column(
        children: [
          if (invoice.tripNumber != null)
            _metaRowBilingual(
              labelEn: 'Trip',
              labelAr: 'رحلة',
              value: invoice.tripNumber!,
            ),
          if (invoice.tripNumber != null && dateLabel.isNotEmpty)
            pw.SizedBox(height: 8),
          if (dateLabel.isNotEmpty)
            _metaRowBilingual(
              labelEn: 'Date',
              labelAr: 'التاريخ',
              value: dateLabel,
            ),
        ],
      ),
    );
  }

  static pw.Widget _metaRowBilingual({
    required String labelEn,
    required String labelAr,
    required String value,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                labelEn,
                style: pw.TextStyle(
                  font: _latoRegular,
                  fontSize: 10,
                  color: _muted,
                ),
              ),
              pw.Text(
                labelAr,
                style: pw.TextStyle(
                  font: _cairoRegular,
                  fontSize: 10,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(font: _latoBold, fontSize: 11, color: _navy),
          ),
        ),
      ],
    );
  }

  static pw.Widget _lineItem(InvoiceLine line, String currencyCode) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                line.labelEn,
                style: pw.TextStyle(font: _latoRegular, fontSize: 11, color: _navy),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                line.labelAr,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(font: _cairoRegular, fontSize: 10, color: _navy),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 12),
        _amountText(line.amount, currencyCode, fontSize: 12, bold: true),
      ],
    );
  }

  static pw.Widget _totalSection(InvoiceLine line, String currencyCode) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: pw.BoxDecoration(
        color: _totalBg,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColor.fromInt(0x33080957)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  line.labelEn,
                  style: pw.TextStyle(font: _latoBold, fontSize: 12, color: _navy),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  line.labelAr,
                  style: pw.TextStyle(font: _cairoBold, fontSize: 11, color: _navy),
                ),
              ],
            ),
          ),
          _amountText(line.amount, currencyCode, fontSize: 16, bold: true),
        ],
      ),
    );
  }

  static pw.Widget _amountText(
    double amount,
    String currencyCode, {
    required double fontSize,
    required bool bold,
  }) {
    final formatted = CurrencyDisplay.formatNumber(amount);
    if (!CurrencyDisplay.isSar(currencyCode)) {
      return pw.Text(
        CurrencyDisplay.formatAmount(amount, currencyCode: currencyCode),
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(
          font: bold ? _latoBold : _latoRegular,
          fontSize: fontSize,
          color: _navy,
        ),
      );
    }

    return pw.RichText(
      textAlign: pw.TextAlign.right,
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$formatted ',
            style: pw.TextStyle(
              font: bold ? _latoBold : _latoRegular,
              fontSize: fontSize,
              color: _navy,
            ),
          ),
          pw.TextSpan(
            text: CurrencyDisplay.sarSymbol,
            style: pw.TextStyle(
              font: bold ? _riyalBold : _riyalRegular,
              fontSize: fontSize,
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _dashedSeparator() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: List.generate(
        42,
        (_) => pw.Container(width: 6, height: 1.2, color: _line),
      ),
    );
  }

  static pw.Widget _footer() {
    return pw.Column(
      children: [
        pw.Text(
          AppStrings.tawsilaApplication.tr(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: _latoRegular, fontSize: 9, color: _muted),
        ),
      ],
    );
  }
}
