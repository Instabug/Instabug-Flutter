
import 'package:grinder/grinder.dart';
import 'package:grind_publish/grind_publish.dart' as grind_publish;


@Task('Automatically publishes this package if the pubspec version increases')
autoPublish() async {
  final credentials = grind_publish.Credentials.fromEnvironment();
  await grind_publish.autoPublish('instabug_flutter', credentials);
}

main(List<String> args) {
  grind(args);
}
