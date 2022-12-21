import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacker_news_reader/Components/StoryList.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HackerNewsReaderApp());
}

class HackerNewsReaderApp extends StatelessWidget {
  const HackerNewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return GetMaterialApp(
        title: 'Hacker News Reader',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          colorSchemeSeed: lightColorScheme == null ? Colors.blue : null,
          brightness: Brightness.light,
          // textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          colorSchemeSeed: darkColorScheme == null ? Colors.blue : null,
          brightness: Brightness.dark,
          // textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        ),
        themeMode: ThemeMode.system,
        home: const StoryList(),
      );
    });
  }
}
