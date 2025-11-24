import 'dart:async';
import 'package:checkmate/auth_service.dart';
import 'package:checkmate/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Manual mock for AuthService that extends ChangeNotifier
class MockAuthService extends ChangeNotifier implements AuthService {
  final MockUser _mockUser = MockUser();

  @override
  User? get user => _mockUser;

  @override
  Stream<User?> get userChanges => Stream.value(_mockUser);

  // Unused methods for this test, but required by the interface
  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async => _mockUser;
  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password) async => _mockUser;
  @override
  Future<void> sendPasswordResetEmail(String email) async {}
  @override
  Future<void> signOut() async {}
  
  @override
  Future<User?> signInWithGoogle() async => _mockUser;
  
  Stream<User?> authStateChanges() => Stream.value(_mockUser);
}

// Mock for the User class
class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockAuthService mockAuthService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuthService = MockAuthService();
  });

  Future<void> pumpDashboardScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          Provider<FirebaseFirestore>.value(value: fakeFirestore),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );
  }

  testWidgets('DashboardScreen shows title, chart, and data', (WidgetTester tester) async {
    await fakeFirestore.collection('users').doc('test_uid').collection('bloodSugarReadings').add({
      'value': 120,
      'notes': 'After meal',
      'timestamp': Timestamp.now(),
      'type': 'Fasting',
    });

    await pumpDashboardScreen(tester);
    await tester.pumpAndSettle();

    expect(find.text('CheckMate'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('After meal'), findsOneWidget);
  });

  testWidgets('DashboardScreen shows empty state when no data is available', (WidgetTester tester) async {
    await pumpDashboardScreen(tester);
    await tester.pumpAndSettle();

    expect(find.text('CheckMate'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('No recent readings'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
