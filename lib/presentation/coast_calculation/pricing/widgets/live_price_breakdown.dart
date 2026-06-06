import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../model/offer_price_breakdown_model.dart';
import '../model/pricing_repo.dart';
import 'price_breakdown_widget.dart';

/// Which side of the calculation the entered amount represents.
enum PricingPreviewMode {
  /// Passenger entered the gross they want to pay.
  passengerTotal,

  /// Captain entered the net they want to receive (driver app default).
  captainNet,
}

/// Live, debounced preview of the pricing breakdown for an in-progress
/// amount input. As the user types, this widget calls the backend preview
/// API (no DB write) and renders [PriceBreakdownWidget].
///
/// Debounce is 350ms to avoid spamming the API on every keystroke. In-flight
/// requests are cancelled when the amount changes.
class LivePriceBreakdown extends StatefulWidget {
  final double? amount;
  final PricingPreviewMode mode;
  final String currencyCode;
  final String? displayCurrencyOverride;
  final bool emphasizeCaptainNet;
  final EdgeInsetsGeometry padding;
  final Duration debounce;

  const LivePriceBreakdown({
    Key? key,
    required this.amount,
    this.mode = PricingPreviewMode.captainNet,
    this.currencyCode = 'SAR',
    this.displayCurrencyOverride,
    this.emphasizeCaptainNet = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    this.debounce = const Duration(milliseconds: 350),
  }) : super(key: key);

  @override
  State<LivePriceBreakdown> createState() => _LivePriceBreakdownState();
}

class _LivePriceBreakdownState extends State<LivePriceBreakdown> {
  final PricingRepo _repo = instance<PricingRepo>();

  Timer? _debounceTimer;
  CancelToken? _cancelToken;

  OfferPriceBreakdownModel? _breakdown;
  bool _loading = false;
  String? _error;
  double? _lastFetchedAmount;

  @override
  void initState() {
    super.initState();
    _scheduleFetch();
  }

  @override
  void didUpdateWidget(covariant LivePriceBreakdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount ||
        oldWidget.mode != widget.mode ||
        oldWidget.currencyCode != widget.currencyCode) {
      _scheduleFetch();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _cancelToken?.cancel('disposed');
    super.dispose();
  }

  void _scheduleFetch() {
    _debounceTimer?.cancel();
    final amount = widget.amount;
    if (amount == null || amount <= 0) {
      _cancelToken?.cancel('amount cleared');
      setState(() {
        _breakdown = null;
        _loading = false;
        _error = null;
        _lastFetchedAmount = null;
      });
      return;
    }
    if (amount == _lastFetchedAmount && _breakdown != null) {
      return; // already showing the right answer
    }
    _debounceTimer = Timer(widget.debounce, () => _fetch(amount));
    setState(() => _loading = true);
  }

  Future<void> _fetch(double amount) async {
    _cancelToken?.cancel('superseded');
    final token = CancelToken();
    _cancelToken = token;
    try {
      final result = widget.mode == PricingPreviewMode.passengerTotal
          ? await _repo.previewPassengerOffer(
              passengerTotal: amount,
              currencyCode: widget.currencyCode,
              cancelToken: token,
            )
          : await _repo.previewCaptainOffer(
              captainNet: amount,
              currencyCode: widget.currencyCode,
              cancelToken: token,
            );
      if (!mounted || token.isCancelled) return;
      setState(() {
        _breakdown = result;
        _loading = false;
        _error = null;
        _lastFetchedAmount = amount;
      });
    } catch (e) {
      if (!mounted || token.isCancelled) return;
      setState(() {
        _loading = false;
        _error = AppStrings.priceBreakdownError.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PriceBreakdownWidget(
      breakdown: _breakdown,
      isLoading: _loading,
      errorMessage: _error,
      emphasizeCaptainNet: widget.emphasizeCaptainNet,
      displayCurrencyOverride: widget.displayCurrencyOverride,
      padding: widget.padding,
    );
  }
}
