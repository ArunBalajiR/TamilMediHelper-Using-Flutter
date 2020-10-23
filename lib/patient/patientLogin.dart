import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/bottomAnimation.dart';
// import 'package:medkit/animations/fadeAnimation.dart';
import 'package:medkit/doctor/doctorLogin.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:medkit/patient/patientPanel.dart';

class PatientLogin extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDoctorDetails providerInfo =
        new ProviderDoctorDetails(userDetails.providerId);

    List<ProviderDoctorDetails> providerData =
        new List<ProviderDoctorDetails>();
    providerData.add(providerInfo);

    PatientDetails details = new PatientDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PatientPanel(
                  detailsUser: details,
                )));

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            BackBtn(),
            ImageAvatar(
              assetImage: 'assets/bigPat.png',
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.1, width * 0.05, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "உள்நுளை",
                    style: GoogleFonts.abel(
                        fontSize: height * 0.045, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    'Features',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '1. பல்வேறு வியாதி /மருந்துக்கான விளக்கங்கள்'
                    '\n2. உங்களுக்கு பிடித்த மருத்துவரை சேர்க்க'
                    '\n3. புதிய வியாதி /மருந்தை சேர்க்க அணுகவும்'
                    '\n4. தவறான வியாதி /மருந்தை புகார் அளிக்க '
                    '\n5. அருகிலுள்ள மருந்தாகத்தை தேடு'
                    '\n6. ஆலோசனைகள் / புகார்கள்',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        height: height * 0.002),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: height * 0.013),
                    color: Colors.white,
                    shape: StadiumBorder(),
                    onPressed: () {
                      _signIn(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        WidgetAnimator(
                          Image(
                            image: AssetImage('assets/google.png'),
                            height: height * 0.038,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          'கூகிள் மூலம் உள்நுளைக',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.021),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: height * 0.15),
                width: width,
                height: height * 0.07,
                child: WidgetAnimator(
                  Text(
                    '"The Job You are Struggling for will replace \nYou within a week if you found dead.'
                    '\nபாதுகாப்பாக இருங்கள் !"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: height * 0.018,
                        color: Colors.black.withOpacity(0.3),
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PatientDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDoctorDetails> providerData;

  PatientDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderPatientDetails {
  ProviderPatientDetails(this.providerDetails);

  final String providerDetails;
}
