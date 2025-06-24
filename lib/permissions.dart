import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform; // Ajout de 'show Platform' pour éviter l'erreur sur Web
import 'package:flutter/foundation.dart'; // Utilisation de kIsWeb

class PermissionsManager {
  /// Demande les permissions seulement sur mobile
  static Future<void> requestPermissions() async {
    if (kIsWeb) {
      print("✅ Pas besoin de permissions sur le Web.");
      return;
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      print("❌ Permissions non prises en charge sur cette plateforme.");
      return;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage, // Seulement pour Android/iOS
    ].request();

    if (statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      print("✅ Toutes les permissions sont accordées !");
    } else {
      print("⚠️ Certaines permissions ont été refusées.");
    }
  }
}
