import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/helpers/shared_preferences_helper.dart';
import '../../../../core/utils/helpers/string_helper.dart';
import '../../../user/data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  /// Fetch Google credentials and sign in to Firebase using those credentials
  @override
  Future<UserCredential> getGoogleCredential() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign-in aborted by user');
    }

    final googleAuth = await googleUser.authentication;
    final credentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  /// Sign up a user with Google and create a new user record in Firestore
  @override
  Future<void> signUpWithGoogle() async {
    await getGoogleCredential();

    final googleUser = await GoogleSignIn.standard().signIn();
    final photoUrl = googleUser!.photoUrl ??
        StringHelpers.generateDefaultAvatar(googleUser.displayName!);
    final generatedUsername =
        StringHelpers.generateUsernameByEmail(googleUser.email);
    final userId = const Uuid().v4();

    final userModel = UserModel(
      userId: userId,
      displayName: googleUser.displayName ?? "",
      username: generatedUsername,
      email: googleUser.email,
      photoUrl: photoUrl,
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
    await dataSource.addUserDataToFireStore(userModel);
    await SharedPreferencesHelper.setUserId(userId);
  }

  /// Sign in an existing user using Google credentials
  @override
  Future<void> signInWithGoogle() async {
    try {
      /// Sign out from Firebase and Google to reset credentials
      await signOut();

      final userCredentials = await getGoogleCredential();
      final userEmail = userCredentials.user!.email;

      if (userEmail == null) {
        throw Exception("Login failed: Email not found");
      }

      final userDoc = await dataSource.checkIfUserExists(userEmail);
      final userId = userDoc?.data()?["userId"];

      if (userId == null) {
        throw Exception("Login failed: User not found in the database");
      }

      await SharedPreferencesHelper.setUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out the currently signed-in user from both Firebase and Google
  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.standard().signOut();
  }
}
