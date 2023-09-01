import 'package:flutter/material.dart';
import 'package:wow_shopping/app/app.dart';
import 'package:wow_shopping/backend/di_widget.dart';

void main() {
  runApp(const DIWidget(
    child: ShopWowApp(
      config: AppConfig(
        env: AppEnv.dev,
      ),
    ),
  ));
}
