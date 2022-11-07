import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_app/auth.dart';
import 'package:profile_app/pages/edit_profile_page.dart';
import 'package:profile_app/pages/location_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffF6F8FB),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'My Profile',
              style: GoogleFonts.poppins().copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            color: const Color(0xffF6F8FB),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama',
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(data['username'], style: GoogleFonts.poppins()),
                          const SizedBox(height: 10),
                          Text(
                            'Nomor Telepon',
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data['phone'],
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email',
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(data['email'], style: GoogleFonts.poppins()),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(),
                      ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    'My Location',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: signOut,
            backgroundColor: Colors.red,
            child: const Icon(Icons.logout),
          ),
        );
      },
    );
  }

  // Future<void> signOut() async {
  //   await Auth().signOut();
  // }

  // Widget _title() {
  //   return const Text('Home Page');
  // }

  // Widget _userUid() {
  //   return Column(
  //     children: [
  //       const Text('Selamat Datang'),
  //       const SizedBox(height: 5),
  //       Text(user?.email ?? 'User email'),
  //     ],
  //   );
  // }

  // Widget _signOutButton() {
  //   return ElevatedButton(
  //     onPressed: signOut,
  //     child: const Text('Sign Out'),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: _title(),
  //     ),
  //     body: Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           _userUid(),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Navigator.push(context,
  //               //     MaterialPageRoute(builder: (context) => LocationPage()));
  //             },
  //             child: Text('My Location'),
  //           ),
  //           _signOutButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
