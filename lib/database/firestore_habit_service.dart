import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ensure the user is signed in (anonymous for now)
  Future<String> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    return userCredential.user!.uid;
  }

  // Add a new habit
  Future<void> addHabit(String title) async {
    final uid = _auth.currentUser?.uid ?? await signInAnonymously();
    await _firestore.collection('users').doc(uid).collection('habits').add({
      'title': title,
      'created_at': FieldValue.serverTimestamp(),
      'completed_dates': [],
      'streak': 0,
    });
  }

  // Mark habit as completed today
  Future<void> markCompleted(String habitId) async {
    final uid = _auth.currentUser?.uid ?? await signInAnonymously();
    final docRef = _firestore.collection('users').doc(uid).collection('habits').doc(habitId);
    await docRef.update({
      'completed_dates': FieldValue.arrayUnion([Timestamp.now()]),
    });
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    final uid = _auth.currentUser?.uid ?? await signInAnonymously();
    await _firestore.collection('users').doc(uid).collection('habits').doc(habitId).delete();
  }

  // Stream all habits
  Stream<QuerySnapshot> habitsStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
