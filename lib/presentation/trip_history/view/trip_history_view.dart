import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_models.dart';
import 'package:taxi_for_you/presentation/trip_history/model/trip_history_repo.dart';
import 'package:taxi_for_you/presentation/trip_history/view/trip_invoice_view.dart';
import 'package:taxi_for_you/utils/api_error_formatter.dart';
import 'package:taxi_for_you/utils/currency_display.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

enum _HistoryFilter { all, last7Days, last30Days, custom }

class TripHistoryView extends StatefulWidget {
  const TripHistoryView({Key? key}) : super(key: key);

  @override
  State<TripHistoryView> createState() => _TripHistoryViewState();
}

class _TripHistoryViewState extends State<TripHistoryView> {
  final TripHistoryRepo _repo = instance<TripHistoryRepo>();
  final AppPreferences _prefs = instance<AppPreferences>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _HistoryFilter _filter = _HistoryFilter.all;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _loading = true;
  String? _error;
  List<TripHistoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userId = _prefs.getCachedDriver()?.id;
      if (userId == null) {
        throw Exception('Driver not logged in');
      }
      final items = await _repo.getDriverHistory(
        userId: userId,
        dateFilter: _buildDateFilter(),
      );
      if (!mounted) return;
      setState(() {
        _items = items;
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

  DateFilterRequest? _buildDateFilter() {
    final now = DateTime.now();
    switch (_filter) {
      case _HistoryFilter.all:
        return null;
      case _HistoryFilter.last7Days:
        final start = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 7));
        return DateFilterRequest(
          startDate: start.millisecondsSinceEpoch.toString(),
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
              .millisecondsSinceEpoch
              .toString(),
        );
      case _HistoryFilter.last30Days:
        final start = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 30));
        return DateFilterRequest(
          startDate: start.millisecondsSinceEpoch.toString(),
          endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
              .millisecondsSinceEpoch
              .toString(),
        );
      case _HistoryFilter.custom:
        if (_fromDate == null && _toDate == null) return null;
        return DateFilterRequest(
          startDate: _fromDate != null
              ? DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day)
                  .millisecondsSinceEpoch
                  .toString()
              : null,
          endDate: _toDate != null
              ? DateTime(_toDate!.year, _toDate!.month, _toDate!.day, 23, 59,
                      59, 999)
                  .millisecondsSinceEpoch
                  .toString()
              : null,
        );
    }
  }

  Future<void> _pickCustomRange() async {
    final pickedFrom = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedFrom == null) return;
    if (!mounted) return;
    final pickedTo = await showDatePicker(
      context: context,
      initialDate: _toDate ?? pickedFrom,
      firstDate: pickedFrom,
      lastDate: DateTime.now(),
    );
    if (pickedTo == null) return;
    setState(() {
      _filter = _HistoryFilter.custom;
      _fromDate = pickedFrom;
      _toDate = pickedTo;
    });
    await _loadHistory();
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
        body: Column(
          children: [
            _buildTopBar(context),
            _filterBar(),
            Expanded(child: _body()),
          ],
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
            AppStrings.tripHistory.tr(),
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

  Widget _filterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _chip(AppStrings.filterAll.tr(), _HistoryFilter.all),
          _chip(AppStrings.filterLast7Days.tr(), _HistoryFilter.last7Days),
          _chip(AppStrings.filterLast30Days.tr(), _HistoryFilter.last30Days),
          ActionChip(
            label: Text(AppStrings.filterCustomRange.tr()),
            onPressed: _pickCustomRange,
            backgroundColor: _filter == _HistoryFilter.custom
                ? ColorManager.splashBGColor.withOpacity(0.15)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, _HistoryFilter value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == value,
        onSelected: (_) async {
          setState(() => _filter = value);
          await _loadHistory();
        },
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(child: Text(AppStrings.tripHistoryEmpty.tr()));
    }
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => _tripCard(_items[index]),
      ),
    );
  }

  Widget _tripCard(TripHistoryItem item) {
    final dateLabel = (item.completionDate ?? item.creationDate ?? '')
        .getTimeStampFromDate(pattern: 'dd MMM yyyy');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripInvoiceView(tripId: item.tripId),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.tripNumber ?? '#${item.tripId}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontFamily: FontConstants.fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CurrencyDisplay.amountText(
                    item.totalAmount,
                    currencyCode: item.currencyCode,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: ColorManager.splashBGColor,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                ],
              ),
              if (dateLabel.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorManager.headersTextColor,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ],
              if (item.pickupLocation.address?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  '${AppStrings.from.tr()}${item.pickupLocation.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorManager.headersTextColor,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              ],
              if (item.destination.address?.isNotEmpty == true)
                Text(
                  '${AppStrings.to.tr()}${item.destination.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorManager.headersTextColor,
                    fontFamily: FontConstants.fontFamily,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.viewInvoice.tr(),
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorManager.splashBGColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontConstants.fontFamily,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: ColorManager.splashBGColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
