import 'package:flutter/material.dart';

import 'package:nakcare_app/controller/provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadAvatarImage();
    Provider.of<UserProvider>(context, listen: false).loadName();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Nak',
                                  style: TextStyle(
                                    color: Color(0xFF3186C6),
                                    fontFamily: 'Manrope',
                                    fontSize: 38,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Safe',
                                  style: TextStyle(
                                    color: Color(0xFFFBBA63),
                                    fontFamily: 'Manrope',
                                    fontSize: 38,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  width: 300,
                                  margin:
                                      const EdgeInsets.only(top: 60, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListView(
                                    padding: const EdgeInsets.all(8.0),
                                    shrinkWrap: true,
                                    children: const <Widget>[
                                      ListTile(
                                        leading:
                                            Icon(Icons.notification_important),
                                        title: Text('Notification 1'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const ClipOval(
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: Color(0xFF3186C6),
                          size: 35,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 70),
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(20),
                        )),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Provider.of<UserProvider>(context, listen: false)
                                  .pickImage(),
                          child: Consumer<UserProvider>(
                            builder: (context, userProvider, child) =>
                                CircleAvatar(
                              backgroundColor: Color(0xFF3186C6),
                              radius: 50,
                              backgroundImage: userProvider.avatarImage != null
                                  ? FileImage(userProvider.avatarImage!)
                                  : null,
                              child: userProvider.avatarImage == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.grey[200],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Consumer<UserProvider>(
                            builder: (context, userProvider, child) =>
                                TextField(
                              controller: TextEditingController(
                                  text: userProvider.parentName),
                              cursorColor: Color(0xFF3186C6),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Color(0xFF3186C6),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none,
                                labelText: 'Parent\'s Name',
                                suffixIcon:
                                    Icon(Icons.edit, color: Color(0xFF3186C6)),
                                focusColor: Color(0xFF3186C6),
                              ),
                              onSubmitted: (value) {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .saveparentName(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Consumer<UserProvider>(
                            builder: (context, userProvider, child) =>
                                TextField(
                              controller: TextEditingController(
                                  text: userProvider.childName),
                              cursorColor: Color(0xFF3186C6),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Child\'s Name',
                                labelStyle: TextStyle(
                                    color: Color(0xFF3186C6),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                suffixIcon:
                                    Icon(Icons.edit, color: Color(0xFF3186C6)),
                                focusColor: Color(0xFF3186C6),
                              ),
                              onSubmitted: (value) {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .savechildName(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Consumer<UserProvider>(
                            builder: (context, userProvider, child) =>
                                TextField(
                              controller: TextEditingController(
                                  text: userProvider.childWeight?.toString() ??
                                      ''),
                              cursorColor: Color(0xFF3186C6),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Child\'s Weight',
                                labelStyle: TextStyle(
                                    color: Color(0xFF3186C6),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                suffixIcon:
                                    Icon(Icons.edit, color: Color(0xFF3186C6)),
                                suffixText:
                                    'kg', // show 'kilogram' beside the input field
                                focusColor: Color(0xFF3186C6),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true), // allow decimal input
                              onSubmitted: (value) {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .savechildWeight(double.parse(value)
                                        .toString()); // parse double to string
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
