import 'package:e_serve/Controlers/user_controllers.dart';
import 'package:flutter/material.dart';

import '../Models/user_model.dart';

class UserProfilePage extends StatefulWidget {
  final UserMap user; // Pass the user details to the page

  const UserProfilePage(this.user, {Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(user);
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _email;
  late TextEditingController _displayName;
  final UserMap user;

  _UserProfilePageState(this.user);

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.user.email);
    _displayName = TextEditingController(text: widget.user.displayName);
  }

  @override
  void dispose() {
    _email.dispose();
    _displayName.dispose();
    super.dispose();
  }

  void _updateProfile() {
    final email = _email.text;
    final name = _displayName.text;
    // Here you can call a function to update the user's profile with the
    // values from the text fields (_emailController.text and _displayNameController.text)
    // For example:
    // updateUserProfile(widget.user.uid, _emailController.text, _displayNameController.text);
    updateUserProfile(user.id, email, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 215, 35, 35),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 3, // Add a slight elevation to the card
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Card(
              elevation: 3, // Add a slight elevation to the card
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextFormField(
                controller: _displayName,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

// class UserProfilePage extends StatelessWidget {
//   final UserMap user; // Pass the user details to the page

//   const UserProfilePage(this.user, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text('Email: ${user.email ?? 'No Email field'}'),
//             Text('Name: ${user.displayName ?? 'No Displayed Name'}'),
//             // Display other user details here
//           ],
//         ),
//       ),
//     );
//   }
// }
