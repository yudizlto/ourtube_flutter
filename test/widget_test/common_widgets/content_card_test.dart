import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourtube/core/presentation/widgets/content_card.dart';

/// Custom HttpOverrides class to bypass SSL certificate verification in tests
/// This is useful when loading network images in tests, but it should **not** be used in production
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Allow all certificates
  }
}

void main() {
  /// Set up custom HttpOverrides globally before running tests
  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
  });

  /// Mock data for testing ContentCard component
  const mockThumbnail = 'https://example.com/image.jpg';
  const mockTitle = 'Mock Video Title';
  const mockChannel = 'Mock Channel Name';

  group("Widget test for ContentCard", () {
    testWidgets('ContentCard displays data correctly with a valid thumbnail',
        (WidgetTester tester) async {
      /// Render the ContentCard widget inside a MaterialApp and Scaffold
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ContentCard(
            thumbnail: mockThumbnail,
            title: mockTitle,
            channelName: mockChannel,
          ),
        ),
      ));

      /// Wait for all widget animations and network images to complete rendering
      await tester.pumpAndSettle();

      /// Verify that the title and channel name are displayed correctly
      expect(find.text(mockTitle), findsOneWidget);
      expect(find.text(mockChannel), findsOneWidget);
    });
  });
}
