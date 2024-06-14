import 'package:flutter/material.dart';
import 'package:nakcare_app/page/HomeNavBar.dart';

class VerifyKit extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final bool _isObscured = true;
  String _serialNumber = '12345678';

  VerifyKit({Key? key}) : super(key: key);

  Future<void> _showSuccessDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          content: Container(
            width: 200,
            height: 300,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.private_connectivity_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                    height:
                        20), // Add some spacing between the icon and the text
                Text(
                  'Your kit is verified. You are now connected to NakSafe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF3186C6), fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFailureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF3186C6),
          title: Text(
            'Failure',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'The serial number does not match.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _verifyAndNavigate(BuildContext context) async {
    if (_controller.text == _serialNumber) {
      await _showSuccessDialog(context);
      await Future.delayed(Duration(seconds: 3));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBarPage()),
      );
    } else {
      _showFailureDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nak',
                      style: TextStyle(
                        color: Color(0xFF3186C6),
                        fontFamily: 'Manrope',
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'Safe',
                      style: TextStyle(
                        color: Color(0xFFFBBA63),
                        fontFamily: 'Manrope',
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 160),
            const Center(
              child: Text(
                "Verification Serial Number",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3186C6),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "Enter the serial number from your NakSafe kit.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              obscureText: _isObscured,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Handle visibility toggle
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _verifyAndNavigate(context),
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3186C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
