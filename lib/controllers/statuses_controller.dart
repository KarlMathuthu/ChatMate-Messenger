import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusController {
  final CollectionReference statusCollection =
      FirebaseFirestore.instance.collection('statuses');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List to store statuses.
  List<QueryDocumentSnapshot> statuses = [];

  // Function to add a new status to Firestore.
  Future<void> addStatus(String statusText) async {
    try {
      String userId = _auth.currentUser!.uid;
      await statusCollection.doc(userId).set({
        'statusText': statusText,
        'timestamp': DateTime.now(),
        'viewers': []
      });
    } catch (e) {
      print('Error adding status: $e');
    }
  }

  // Function to delete a status by its ID.
  Future<void> deleteStatus(String statusId) async {
    try {
      // Delete the document with the given statusId.
      await statusCollection.doc(statusId).delete();
    } catch (e) {
      // Handle any errors that occur during the operation.
      print('Error deleting status: $e');
    }
  }

  // Function to add the current user's UID to the "viewers" array of a specific status.
  Future<void> addCurrentUserToViewers(String statusId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Get the status document by its ID.
        DocumentReference statusRef = statusCollection.doc(statusId);

        // Update the "viewers" array to add the current user's UID.
        await statusRef.update({
          'viewers': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    } catch (e) {
      // Handle any errors that occur during the operation.
      print('Error adding current user to viewers: $e');
    }
  }

  // Function to listen to changes in the 'statuses' collection and update the 'statuses' list.
  void viewStatus(Function(List<QueryDocumentSnapshot>) onStatusUpdate) {
    statusCollection.snapshots().listen((QuerySnapshot querySnapshot) {
      statuses = querySnapshot.docs;
      // Call the provided callback function to update the UI with the latest statuses.
      onStatusUpdate(statuses);
    });
  }
}
