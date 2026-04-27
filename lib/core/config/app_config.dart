class AppConfig {
  const AppConfig._();

  /// Default local backend URL (iOS simulator / desktop).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8001',
  );

  /// Handy alternative for Android emulator networking.
  static const String androidEmulatorApiBaseUrl = 'http://10.0.2.2:8001';

  /// If true, drama read APIs fall back to local mock data when API fails.
  static const bool enableMockFallback = bool.fromEnvironment(
    'ENABLE_MOCK_FALLBACK',
    defaultValue: true,
  );
}
