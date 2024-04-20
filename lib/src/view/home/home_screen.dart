import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/src/view/auth/login_screen.dart';
import 'package:firebase_project/src/view/course/create_course_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  CollectionReference dataRef =
      FirebaseFirestore.instance.collection("Courses");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(children: [
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false));
              },
              title: const Text('Sign Out'),
              trailing: const Icon(Icons.logout),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 200))
                    .whenComplete(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEditCourseScreen(
                                  courseData: null,
                                  refId: '',
                                ))));
              },
              title: const Text('Create Course'),
              trailing: const Icon(Icons.file_copy),
            )
          ]),
        ),
      ),
      appBar: AppBar(
        title: const Text('W.E.L.C.O.M.E'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: prefer_const_constructors
            return Center(
              child: const Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return courseCard(context,
                      data: data, refId: snapshot.data!.docs[index].id);
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data!.docs.length);
          }
        },
      ),
    );
  }

  Widget courseCard(BuildContext context,
      {required Map data, required String refId}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  CachedNetworkImage(
                    height: 120,
                    width: 120,
                    imageUrl: data['image'],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['course_name'],
                      ),
                      Text(
                        "\$ ${double.parse(data['price'].toString())}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                right: 0,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await dataRef.doc(refId).delete();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditCourseScreen(
                                        courseData: data,
                                        refId: refId,
                                      )));
                        },
                        icon: const Icon(
                          Icons.edit_document,
                          color: Colors.blueAccent,
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
