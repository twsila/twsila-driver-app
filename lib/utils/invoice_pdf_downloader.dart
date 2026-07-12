import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class InvoicePdfDownloader {
  InvoicePdfDownloader._();

  static String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
  }

  static Future<String> saveToDevice({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final safeName = _sanitizeFileName(fileName);
    final directory = await _resolveSaveDirectory();
    final file = File('${directory.path}/$safeName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<Directory> _resolveSaveDirectory() async {
    if (Platform.isAndroid) {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) {
        if (!await downloads.exists()) {
          await downloads.create(recursive: true);
        }
        return downloads;
      }
    }

    final documents = await getApplicationDocumentsDirectory();
    final invoicesDir = Directory('${documents.path}/Invoices');
    if (!await invoicesDir.exists()) {
      await invoicesDir.create(recursive: true);
    }
    return invoicesDir;
  }

  static Rect shareOriginFromContext(
    BuildContext context, {
    GlobalKey? anchorKey,
  }) {
    final anchorContext = anchorKey?.currentContext;
    if (anchorContext != null) {
      final renderObject = anchorContext.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final offset = renderObject.localToGlobal(Offset.zero);
        final rect = offset & renderObject.size;
        if (rect.width > 0 && rect.height > 0) {
          return rect;
        }
      }
    }

    final size = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(
      size.width / 2 - 1,
      size.height - 72,
      2,
      2,
    );
  }

  static Future<void> shareFile(
    String filePath, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'application/pdf')],
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
