import 'dart:io';

void main() async {
  print('version?');
  final version = stdin.readLineSync()!.trim();

  print('Updating root README from route_pattern_generator');
  copy("route_pattern_generator/README.md", "README.md");

  await updatePubspec(
      "route_pattern", (content) => updateVersion(content, version));
  await updatePubspec("route_pattern_generator", (content) {
    content = updateVersion(content, version);
    content = content.substring(0, content.indexOf("dependency_overrides:"));
    return updateDependency(content, "route_pattern", version);
  });

  print('Confirm publish ? (y/n)');
  if (stdin.readLineSync()!.trim() == 'y') {
    await publish("route_pattern");
    await publish("route_pattern_generator");
  }

  await updatePubspec("route_pattern_generator", (content) {
    return content +
        "dependency_overrides:\n  route_pattern:\n    path: ../route_pattern";
  });
}

Future publish(String folder) async {
  final result = await Process.run(
    'pub',
    ['publish', '-f'],
    workingDirectory: folder,
  );
  print(result.stdout);
  if (result.exitCode != 0) {
    print(result.stderr);
  }
}

Future copy(String source, String destination) async {
  final sourceFile = File(source);
  sourceFile.copy(destination);
}

Future updatePubspec(String folder, String update(String content)) async {
  final pubspec = File("$folder/pubspec.yaml");
  String pubspecContent;
  print("Updating $pubspec...");
  pubspecContent = await pubspec.readAsString();
  pubspecContent = update.call(pubspecContent);
  await pubspec.writeAsString(pubspecContent);
}

String updateVersion(String content, String version) =>
    content.replaceAllMapped(
        RegExp("version:(\\s)*[^\\r\\n]+"), (m) => "version: $version");

String updateDependency(String content, String dependency, String version) =>
    content.replaceAllMapped(RegExp("$dependency:(\\s)*[^\\r\\n]+"),
        (m) => "$dependency: ^$version");
