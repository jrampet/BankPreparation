import 'package:flutter/material.dart';

import 'data/local/progress_repository.dart';
import 'domain/progress_controller.dart';
import 'presentation/prepquest_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ProgressController(
    repository: await SqliteProgressRepository.open(),
  );
  await controller.load();
  runApp(PrepQuestApp(controller: controller));
}
