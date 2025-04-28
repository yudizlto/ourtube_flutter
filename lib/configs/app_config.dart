import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env["SUPABASE_URL"]!;
  static String get supabaseAnonKey => dotenv.env["SUPABASE_ANON_KEY"]!;
  static String get apiKey => dotenv.env["API_KEY"]!;
  static String get apiBaseUrl => dotenv.env["API_BASE_URL"]!;
}
