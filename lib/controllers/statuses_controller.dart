import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/status_model.dart';

class StatusController {
  final CollectionReference statusCollection =
      FirebaseFirestore.instance.collection('statuses');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to add a new status to Firestore using StatusModel.
  Future<void> addStatus(String statusText) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final StatusModel status = StatusModel(
          text: statusText,
          timestamp: Timestamp.fromDate(DateTime.now()),
        );

        await statusCollection.doc(currentUser.uid).update({
          'status': FieldValue.arrayUnion([status.toMap()])
        });
      }
    } catch (e) {
      // Handle any errors that occur during the operation.
      print('Error adding status: $e');
    }
  }

// Function to add the current user's UID to the "viewers" array of a specific status.
  Future<void> addCurrentUserToViewers(String statusId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Get the status document by its ID.
        DocumentReference statusRef = statusCollection.doc(statusId);

        // Fetch the document to check if the current user's UID is in the "viewers" array.
        DocumentSnapshot statusDoc = await statusRef.get();

        // Get the current viewers array and the user's UID.
        List<dynamic> viewers = statusDoc.get('viewers') ?? [];
        String userUid = currentUser.uid;

        // Check if the user's UID is not already in the viewers array before updating it.
        if (!viewers.contains(userUid)) {
          viewers.add(userUid);

          // Update the "viewers" array with the updated list.
          await statusRef.update({'viewers': viewers});
        }
      }
    } catch (e) {
      // Handle any errors that occur during the operation.
      print('Error adding current user to viewers: $e');
    }
  }

// Function to listen to changes in the current user's statuses.
  void viewStatus(Function(List<StatusModel>) onStatusUpdate) {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Query the Firestore collection for the current user's statuses.
      statusCollection.doc(currentUser.uid).get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          final List<dynamic>? statusData = doc['status'];
          if (statusData != null) {
            final List<StatusModel> statuses = statusData
                .map((status) => StatusModel.fromMap(status))
                .toList();
            onStatusUpdate(statuses);
          }
        }
      }).catchError((e) {
        // Handle any errors that occur during the operation.
        print('Error fetching statuses: $e');
      });
    }
  }

  // Function to delete a status from the array of statuses under the current user's document.
  Future<void> deleteStatus(String statusText) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await statusCollection.doc(currentUser.uid).update({
          'status': FieldValue.arrayRemove(
            [
              {
                'text': statusText,
              }
            ],
          )
        });
      }
    } catch (e) {
      // Handle any errors that occur during the operation.
      print('Error deleting status: $e');
    }
  }
}
