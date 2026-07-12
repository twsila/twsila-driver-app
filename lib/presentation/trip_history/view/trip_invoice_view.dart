import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_models.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_repo.dart';
import 'package:taxi_for_you/presentation/trip_history/view/widgets/bilingual_invoice_widget.dart';
import 'package:taxi_for_you/utils/api_error_formatter.dart';
import 'package:taxi_for_you/utils/invoice_pdf_downloader.dart';
import 'package:taxi_for_you/utils/invoice_pdf_generator.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

class TripInvoiceView extends StatefulWidget {
  final int tripId;

  const TripInvoiceView({Key? key, required this.tripId}) : super(key: key);

  @override
  State<TripInvoiceView> createState() => _TripInvoiceViewState();
}

class _TripInvoiceViewState extends State<TripInvoiceView> {
  final TripHistoryRepo _repo = instance<TripHistoryRepo>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _downloadButtonKey = GlobalKey();

  bool _loading = true;
  bool _downloading = false;
  String? _error;
  TripInvoice? _invoice;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final invoice = await _repo.getCaptainInvoice(widget.tripId);
      if (!mounted) return;
      setState(() {
        _invoice = invoice;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _formatError(e);
        _loading = false;
      });
    }
  }

  String _formatError(Object e) => formatApiError(e);

  Future<void> _downloadPdf() async {
    if (_invoice == null) return;

    setState(() => _downloading = true);
    try {
      final bytes = await InvoicePdfGenerator.generate(_invoice!);
      final tripRef = _invoice!.tripNumber ?? widget.tripId.toString();
      final fileName = 'Twsila-Invoice-$tripRef.pdf';
      final savedPath = await InvoicePdfDownloader.saveToDevice(
        bytes: bytes,
        fileName: fileName,
      );

      if (!mounted) return;

      Fluttertoast.showToast(msg: AppStrings.invoicePdfSaved.tr());
      final result = await OpenFilex.open(savedPath);
      if (result.type != ResultType.done && mounted) {
        await InvoicePdfDownloader.shareFile(
          savedPath,
          subject: AppStrings.invoice.tr(),
          sharePositionOrigin: InvoicePdfDownloader.shareOriginFromContext(
            context,
            anchorKey: _downloadButtonKey,
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: formatApiError(e));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        scaffoldKey: _scaffoldKey,
        appbar: false,
        context: context,
        allowBackButtonInAppBar: false,
        extendAppBarIntoSafeArea: true,
        body: ColoredBox(
          color: const Color(0xFFF3F4F8),
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 4,
        left: 8,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: ColorManager.splashBGColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
            color: Colors.white,
          ),
          Text(
            AppStrings.invoice.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ColorManager.headersTextColor,
              fontFamily: FontConstants.fontFamily,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: BilingualInvoiceWidget(invoice: _invoice!),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              key: _downloadButtonKey,
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.splashBGColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _downloading ? null : _downloadPdf,
                icon: _downloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded, size: 22),
                label: Text(
                  AppStrings.downloadInvoice.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
