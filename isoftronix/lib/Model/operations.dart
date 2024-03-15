import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isoftronix/Screens/homeScreen.dart';
class Model{
  List<OperationModel> crudList = [
    OperationModel(operation: Operations.create, title: 'CREATE'),
    OperationModel(operation:  Operations.read, title: 'READ'),
    OperationModel(operation: Operations.update, title: 'UPDATE'),
    OperationModel(operation: Operations.delete, title: 'DELETE'),
  ];

  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static String COLLECTION ='Products';

  static Future<void> createProduct({required String productName, required int  price}) async {
    DocumentReference  referenceToDocumentId =
    firebaseFirestore.collection(COLLECTION).doc();
    await referenceToDocumentId.set({
      'ProductName' : productName,
      'ProductPrice' : price
    });
  }

    static Stream<QuerySnapshot<Map<String, dynamic>>> readProduct(){
    return firebaseFirestore.collection(COLLECTION).snapshots();
  }

  static  void deleteProduct({required String id}) async {
    await firebaseFirestore.collection(COLLECTION).doc(id).delete();
  }

  static void updateProduct({required String id ,required String name , required int price}){
    DocumentReference  referenceToDocumentId =
    firebaseFirestore.collection(COLLECTION).doc(id);
    referenceToDocumentId.update({
      'ProductName' : name,
      'ProductPrice' : price
    });
  }
}
class OperationModel{
  String title ;
  Operations operation;
  OperationModel({required this.operation, required this.title});
}