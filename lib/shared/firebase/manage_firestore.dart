import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/component.dart';

class ManageFireStore {
  static Future set({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    FirebaseFirestore.instance.collection(collection).doc(document).set(data);
  }

  static Future update({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .update(data);
  }

  static Future delete({
    required String collection,
    required String document,
  }) async {
    FirebaseFirestore.instance.collection(collection).doc(document).delete();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String document,
  }) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .get();
  }

  static Future setIntoTwoDocuments({
    required String collection,
    required String document,
    required String secondCollection,
    required String secondDocument,
    required Map<String, dynamic> data,
  }) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(document)
        .collection(secondCollection)
        .doc(secondDocument)
        .set(data);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getListWithWhere({
    required String collection,
    required String document,
    String? orderBy,
    bool descending = false,
  }) async {
    if (orderBy == null)
      return await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: document)
          .get();
    else
      return await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: document)
          .orderBy(orderBy, descending: descending)
          .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getListWithoutWhere({
    required String collection,
    String? orderBy,
    bool descending = false,
  }) async {
    if (orderBy != null)
      return await FirebaseFirestore.instance
          .collection(collection)
          .orderBy(orderBy, descending: descending)
          .get();
    else
      return await FirebaseFirestore.instance.collection(collection).get();
  }

  static void sendVerificationEmail({required BuildContext context}) {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then(
      (value) {
        Component.buildAlert(
          context: context,
          title: "Send Verification Email",
          body: "Check your mail",
          dialogType: DialogType.INFO,
        );
      },
    ).onError(
      (error, stackTrace) {
        print(error.toString());
        print(stackTrace);
      },
    );
  }

  static Widget buildSendVerificationEmail({required BuildContext context}) {
    return !FirebaseAuth.instance.currentUser!.emailVerified
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(
                .6,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'please verify your email',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                Spacer(),
                Component.defaultTextButton(
                  text: 'send',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    sendVerificationEmail(context: context);
                  },
                ),
              ],
            ),
          )
        : Container();
  }
}
