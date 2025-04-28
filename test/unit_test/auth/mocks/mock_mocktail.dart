import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ourtube/features/auth/domain/repositories/auth_repository.dart';
import 'package:ourtube/features/user/data/models/user_model.dart';

// class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class FakeUserModel extends Fake implements UserModel {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class MockUserCredential extends Mock implements UserCredential {
  final MockFirebaseUser? mockUser;

  MockUserCredential({this.mockUser});

  @override
  User? get user => mockUser;
}

class MockFirebaseUser extends Mock implements User {
  final String? _email;
  final String? _displayName;
  final String? _photoURL;

  MockFirebaseUser({String? email, String? displayName, String? photoURL})
      : _email = email,
        _displayName = displayName,
        _photoURL = photoURL;

  @override
  String? get email => _email;

  @override
  String? get displayName => _displayName;

  @override
  String? get photoURL => _photoURL;
}
