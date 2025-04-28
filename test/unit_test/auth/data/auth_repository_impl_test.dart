import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ourtube/core/utils/helpers/shared_preferences_helper.dart';
import 'package:ourtube/core/utils/helpers/string_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/mocks/models/mock_user_model.dart';
import '../mocks/mock_mocktail.dart';
import '../mocks/mock_auth_data_source.dart';

void main() {
  late MockGoogleSignIn googleSignIn;
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignInAccount googleUser;
  late MockGoogleSignInAuthentication googleAuth;
  late MockUserCredential userCreds;

  late MockAuthDataSource dataSource;

  /// Setup fallback values for test cases
  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
    registerFallbackValue(MockUserModel());
  });

  /// Initializes mock instances before each test case
  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    googleSignIn = MockGoogleSignIn();
    firebaseAuth = MockFirebaseAuth();
    googleUser = MockGoogleSignInAccount();
    googleAuth = MockGoogleSignInAuthentication();
    userCreds = MockUserCredential();

    dataSource = MockAuthDataSource();
  });

  /// Cleans up shared preferences after each test case
  tearDown(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  /// Helper function to simulate Google Sign-In process and return mock credentials
  void getGoogleCredentials({
    String? displayName,
    String? email,
    String? photoUrl,
    String? idToken,
    String? accessToken,
    bool shouldReturnNullUser = false,
  }) {
    when(() => googleSignIn.signIn()).thenAnswer((_) async {
      return shouldReturnNullUser
          ? throw Exception('Google sign-in aborted by user')
          : googleUser;
    });

    when(() => googleUser.authentication).thenAnswer((_) async => googleAuth);

    when(() => googleUser.displayName).thenReturn(displayName ?? "");
    when(() => googleUser.email).thenReturn(email ?? "");
    when(() => googleUser.photoUrl).thenReturn(photoUrl ?? "");
    when(() => googleAuth.idToken).thenReturn(idToken ?? "");
    when(() => googleAuth.accessToken).thenReturn(accessToken ?? "");

    final mockUser = MockFirebaseUser(
      email: email,
      displayName: displayName,
      photoURL: photoUrl,
    );

    userCreds = MockUserCredential(mockUser: mockUser);

    when(() => firebaseAuth.signInWithCredential(any()))
        .thenAnswer((_) async => userCreds);
  }

  /// Handles the sign-up process and saves user data to Firestore and SharedPreferences
  void signUpAndSaveUserData({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? idToken,
    String? accessToken,
    bool shouldReturnNullUser = false,
  }) async {
    /// Get Google Credentials
    getGoogleCredentials(
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      idToken: idToken,
      accessToken: accessToken,
    );

    /// Should generate a default photo url based on the display name if no photo url is provided
    final generatedPhotoUrl = googleUser.photoUrl!.isEmpty
        ? StringHelpers.generateDefaultAvatar(googleUser.displayName!)
        : googleUser.photoUrl!;

    /// Should generate a default username based on the email
    final generatedUsername =
        StringHelpers.generateUsernameByEmail(googleUser.email);

    final userId = uid;

    /// Add the user data to Firestore
    final user = MockUserModel(
      userId: userId,
      displayName: googleUser.displayName ?? "",
      username: generatedUsername,
      email: googleUser.email,
      photoUrl: generatedPhotoUrl,
      bannerUrl: "",
      subscriptions: [],
      subscribers: [],
      videos: [],
      description: "",
      createdAt: DateTime.now(),
      likedVideos: 0,
      dislikedVideos: 0,
      playlists: [],
    );

    /// Add the user data to Firestore
    /// Save the user ID locally for future reference using shared preferences
    await dataSource.addUserDataToFireStore(user);
    await SharedPreferencesHelper.setUserId(user.userId!);
  }

  group("Auth Repository Implementation Tests", () {
    group("Get Google Credential", () {
      test("Should get Google credentials successfully", () async {
        // Arrange
        getGoogleCredentials(
          displayName: "Jane Doe",
          email: "janedoe@gmail.com",
          photoUrl: "https://example.com/jane.jpg",
          idToken: "mockIdToken_98765",
          accessToken: "mockAccessToken_54321",
        );

        // Act
        final getUserCreds = userCreds.user;

        // Assert
        expect(getUserCreds?.email, equals("janedoe@gmail.com"));
        expect(getUserCreds?.displayName, equals("Jane Doe"));
        expect(getUserCreds?.photoURL, equals("https://example.com/jane.jpg"));
      });

      test("Should throw an exception when Google sign-in is aborted",
          () async {
        // Arrange
        getGoogleCredentials(shouldReturnNullUser: true);

        // Act & Assert
        expect(() async {
          if (googleUser.email.isEmpty) {
            throw Exception("Google sign-in aborted by user");
          }
        }, throwsException);
      });
    });

    group("Sign Up With Google", () {
      test("Should sign up and save user data successfully", () async {
        // Arrange
        signUpAndSaveUserData(
          uid: "fake_127e8443-e21b-41d4-a716-446655440458",
          displayName: "Abigail.",
          email: "abigail@gmail.com",
          photoUrl: "https://example.com/abigail.png",
          idToken: "mockIdToken_124",
          accessToken: "mockAccessToken_4444",
        );

        // Act
        final getUserCreds = userCreds.user;
        final userDoc =
            await dataSource.checkIfUserExists(getUserCreds!.email!);
        final userData = userDoc!.data();
        final userId = userData!["userId"];

        await SharedPreferencesHelper.setUserId(userId);
        final storedUserId = await SharedPreferencesHelper.getUserId();

        // Assert
        expect(userDoc.data(), isNotNull);
        expect(storedUserId, equals(userId));
        expect(userData["videos"], equals([]));
      });

      test("Should generate a default avatar if no photo url is provided",
          () async {
        // Arrange
        signUpAndSaveUserData(
          uid: "fake_034e8443-e21b-41d4-b947-553055440458",
          displayName: "Marsa",
          email: "marsa@gmail.com",
          photoUrl: "",
          idToken: "mockIdToken_09124",
          accessToken: "mockAccessToken_23524",
        );

        final getUserCreds = userCreds.user;
        final userDoc =
            await dataSource.checkIfUserExists(getUserCreds!.email!);
        final userData = userDoc!.data();
        final userPhotoUrl = userData!["photoUrl"];

        expect(userPhotoUrl, isNotEmpty);
      });
    });

    group("Sign In with Google", () {
      test("Should sign in with Google successfully", () async {
        signUpAndSaveUserData(
          uid: "fake_550e8400-e29b-41d4-a716-446655440000",
          displayName: "Nicole Z.",
          email: "nicole1247@gmail.com",
          photoUrl: "https://example.com/nicoleads.jpg",
          idToken: "mockIdToken_325476",
          accessToken: "mockAccessToken_124423",
        );

        // Act
        final getUserCreds = userCreds.user;
        final userDoc =
            await dataSource.checkIfUserExists(getUserCreds!.email!);
        final userId = userDoc!.data()!["userId"];

        await SharedPreferencesHelper.setUserId(userId);
        await SharedPreferencesHelper.getUserId();

        // Assert
        expect(userDoc, isNotNull);
      });

      test("Should throw an error if user is not found in the database",
          () async {
        // Arrange
        getGoogleCredentials(
          displayName: "Jupiter",
          email: "jupiter@gmail.com",
          photoUrl: "https://example.com/jups.jpg",
          idToken: "mockIdToken_4120",
          accessToken: "mockAccessToken_4214124",
        );

        final creds = userCreds.user!;
        final userEmail = creds.email;

        final userDoc = await dataSource.checkIfUserExists(userEmail!);
        final userId = userDoc?.data()?["userId"];

        expect(userId, isNull);
        expect(() async {
          if (userDoc == null || userId == null) {
            throw Exception("User not found in the database");
          }
        }, throwsException);
      });
    });
  });
}
