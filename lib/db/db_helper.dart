import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/models/task.dart';

class DbHelper {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _usersCollection = 'Users';

  /*static Future<String> insert(Task task, String userId) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('tasks')
          .add(task.toJson());
      return docRef.id; // Return the document ID of the inserted record
    } catch (e) {
      print('Error inserting task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }*/

  static Future<String> insert(Task task, String userId) async {
    try {
      // Generate a new document reference with a specified ID
      DocumentReference docRef = _firestore.collection('tasks').doc(task.id);

      // Set the data of the document with task.toJson(), excluding 'id'
      await docRef.set({
        ...task.toJson(), // Include all fields from task.toJson()
        'id': docRef.id, // Set 'id' to the document's auto-generated ID
      });

      return docRef.id; // Return the document ID of the inserted record
    } catch (e) {
      print('Error inserting task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }

  static Future<List<Task>> query(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .get();
      List<Task> tasks = snapshot.docs.map((doc) {
        // Ensure the data is cast to Map<String, dynamic>
        return Task.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return tasks;
    } catch (e) {
      print('Error querying tasks: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }

  /*static Future<void> delete(Task task, String userId) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('tasks')
          .doc(task.id ?? '')
          .delete();
    } catch (e) {
      print('Error deleting task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }*/
  /*static Future<void> delete(Task task, String userId) async {
    try {
      if (task.id == null || task.id!.isEmpty) {
        print('Error: Task ID is null or empty.');
        return;
      }
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('tasks')
          .doc(task.id)
          .delete();
      print('Task deleted successfully.');
    } catch (e) {
      print('Error deleting task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }*/
  static Future<void> delete(Task task, String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('tasks')
          .where('title', isEqualTo: task.title) // Replace with appropriate unique identifier
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Error: Task not found.');
        return;
      }

      String docId = querySnapshot.docs[0].id;
      await _firestore
          .collection('tasks')
          .doc(docId)
          .delete();

      print('Task deleted successfully.');
    } catch (e) {
      print('Error deleting task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }

  /*static Future<void> update(Task task, String userId) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('tasks')
          .doc(task.id ?? '')
          .update(task.toJson());
    } catch (e) {
      print('Error updating task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }*/
  static Future<void> update(Task task, String userId) async {
    try {
      // Query Firestore to find the document ID based on the task's ID
      DocumentReference docRef = _firestore.collection('tasks').doc(task.id);

      // Update the document using set method
      await docRef.set(task.toJson()); // This will overwrite the existing document with new data

      print('Task updated successfully.');
    } catch (e) {
      print('Error updating task: $e');
      throw e; // Throw the error to be handled by the caller
    }
  }

}
