import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareCard(GlobalKey cardKey, String pokemonName) async {
    try {
      RenderRepaintBoundary boundary =
      cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/pokemon_$pokemonName.png');

        final Uint8List pngBytes = byteData.buffer.asUint8List();
        await file.writeAsBytes(pngBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: '¡Mira este Pokémon!',
        );
      }
    } catch (e) {
      print('Error al compartir: $e');
    }
  }
}