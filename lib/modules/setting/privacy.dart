import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:riderapps/constance/routes.dart';
import 'package:riderapps/modules/setting/myProfile.dart';
import 'package:riderapps/constance/constance.dart' as constance;
import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();

}

class _PrivacyScreenState extends State<PrivacyScreen> {
  var fullName;
  var email;
  var phone;

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
      Stack(
      children: <Widget>[
        Container(
        height: 150,
        color: Theme.of(context).primaryColor,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top + 16,
          ),
          Padding(
            padding: EdgeInsets.only(right: 14, left: 14),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of('Privacy Policy'),
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
      ],
    ),
    Expanded(
    child: ListView(
    padding: EdgeInsets.all(0),
    children: <Widget>[
    Container(
    color: Theme.of(context).backgroundColor,
    child: Column(
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.all(30.0),
    child: Container(
    child: Text(
    'At Shamrock Ride, we want to create access through transportation and increase the quality of life for millions of people who require accessibility in transportation. This privacy policy outlines information Shamrock Ride receives from riders and drivers, and how we use it to connect riders with drivers and continue to improve our services.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'Scope of this Privacy Policy',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Shamrock Ride (Shamrock Ride,our, and/or) values the privacy of individuals who use our application, websites, and related services (collectively, theShamrock Ride Platform). This privacy policy (the Privacy Policy) explains how we collect, use, and share information from Shamrock Ride users (Users), comprised of both Shamrock Ride riders (Riders) and Shamrock Ride drivers (including Driver applicants) ( Drivers). Beyond the Privacy Policy, your use of Shamrock Ride is also subject to our Terms of Service.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'Information We Collect',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Registration Information. When you sign up for a Shamrock Ride account, you give us your name, email address, and phone number.User Profile Information.When you join the Shamrock Ride community, you can create a Shamrock Ride Profile to share information about yourself. Filling out a profile better helps Shamrock Ride drivers assess your specific transportation needs if any. Your name (and for Drivers, Profile photos) is always part of your Profile. Read more below about how you can control who sees your Profile.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Payment Method. When you add a credit card or payment method to your Shamrock Ride account, a third party that handles payments for us will receive your card information. To keep your financial data secure, we do not store full credit card information on our servers'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Communications. If you contact us directly, we may receive additional information about you. For example, when you contact our Customer Support Team, we will receive your name, email address, phone number, the contents of a message or attachments that you may send to us, and other information you choose to provide.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Driver Application Information. If you decide to join our Shamrock Ride driver community, in addition to the basic registration information we ask you for your date of birth, physical address, Social Security number, drivers license information, vehicle information, car insurance information, and in some jurisdictions we may collect additional business license or permitting information. We share this information with our partners who help us by running background checks on Drivers to help protect the Shamrock Ride community.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Payment Information. To make sure Drivers get paid, we keep information about Drivers bank numbers, tax information, and any other payment information provided by Drivers.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'Information We Collect When You Use the Shamrock Ride Platform Location Information',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Shamrock Ride is all about connecting Drivers and Riders. To do this, we need to know where you are. When you open Shamrock Ride on your mobile device, we receive your location. We may also collect the precise location of your device when the app is running in the foreground or background. If you label certain locations, such as home and work we receive that information, too. Your location information is necessary for things like matching Riders with nearby Drivers, determining drop off and pick up locations, and suggesting destinations based on previous trips. Also, if the need ever arises, our Safety team may use and share location information to help protect the safety of Shamrock Ride Users or a member of the public. In addition to the reasons described above, Driverslocation information and distance travelled is necessary for calculating charges and insurance for Shamrock Ride rides. If you give us permission through your device settings or Shamrock Ride app, we may collect your location while the app is off to identify promotions or service updates in your area.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Device Information. Shamrock Ride receives information from Users devices, including IP address, web browser type, mobile operating system version, phone carrier and manufacturer, application installations, device identifiers, mobile advertising identifiers, push notification tokens, and, if you register with your Facebook account, your Facebook identifier. We collect mobile sensor data from Driversdevices (such as speed, direction, height, acceleration or deceleration) to improve location accuracy and analyze usage patterns.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Usage Information. To help us understand how you use the Shamrock Ride Platform and to help us improve it, we automatically receive information about your interactions with the Shamrock Ride Platform, like the pages or other content you view, your actions within the Shamrock Ride app, and the dates and times of your visits.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Call and Text Information. We work with a third party partner to facilitate phone calls and text messages between Riders and Drivers who have been connected for a ride. We receive information about these communications including the date and time of the call or SMS message, the parties phone numbers, and the content of any SMS messages. For security purposes, we may also monitor and/or record the contents of phone calls made on the Shamrock Ride Platform, such as those between Riders and Drivers. You will be given notice that your call may be recorded, and by proceeding you agree to allow Shamrock Ride to monitor and/or record your call. User Feedback. At Shamrock Ride, we want to make sure Users are always enjoying great rides. Riders and Drivers may rate and review each other at the end of every ride. We receive information about ratings and reviews and, as we explain below, give Riders information about Driversratings and reviews and vice versa.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Information from Cookies and Similar Technologies. We collect information through the use of cookies, tracking pixels, and similar technologies to understand how you navigate through the Shamrock Ride Platform and interact with Shamrock Ride advertisements, to learn what content is popular, and to save your preferences. Cookies are small text files that web servers place on your device; they are designed to store basic information and to help websites and apps recognize your browser. We may use both session cookies and persistent cookies. A session cookie disappears after you close your browser. A persistent cookie remains after you close your browser and may be accessed every time you use the Shamrock Ride Platform. You should consult your web browser(s) to modify your cookie settings. Please note that if you delete or choose not to accept cookies from us, you may be missing out on certain features of the Shamrock Ride Platform.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'Information We Collect from Third Parties',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Third Party Services. If you choose to register for Shamrock Ride or otherwise link your Shamrock Ride account with a third partys service (such as Facebook), we may receive the same type of information we collect from you (described above) directly from those services.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Third Party Partners. We may receive additional information about you, such as demographic data, payment information, or fraud detection information, from third party partners and combine it with other information that we have about you.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Access Programs. If your company, university, or organization participates in one of our access programs we may receive information about you, such as your email address, from your participating organization. We also may give your participating organization the opportunity to request a ride on your behalf, in which case they may provide us with your name, phone number, and the pickup and drop off location for your ride.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Background Information on Drivers. Shamrock Ride works with third party partners to perform driving record and criminal background checks on Drivers, and we receive information from them such as publicly available information about a Drivers driving record or criminal history.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'How We Use the Information We Collect',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'We use the information we collect from all Users to: Connect Riders with Drivers; Provide, improve, expand, and promote the Shamrock Ride Platform; Analyze how the Shamrock Ride community uses the Shamrock Ride Platform; Communicate with you, either directly or through one of our partners, including for marketing and promotional purposes; Personalize the Shamrock Ride experience for you and your friends and contacts; Send you text messages and push notifications; Facilitate transactions and payments; Provide you with customer support; Find and prevent fraud; and Respond to trust and safety issues that may arise, including auto incidents, disputes between Riders and Drivers, and requests from government authorities. Additionally, we use the information we collect from Drivers for the following purposes related to driving on the Shamrock Ride Platform: Sending emails and text messages to Drivers who have started the driver application process regarding the status of their application;Determining a Drivers eligibility to drive for Shamrock Ride Notifying Drivers about ride demand, pricing and service updates; and Calculating and providing Shamrock Rides auto insurance policy and analyzing usage patterns for safety and insurance purposes. How We Share the Information We Collec Sharing Between User Sharing between Riders and Drivers.Riders and Drivers that have been matched for a ride are able to see basic information about each other, such as names, photo, ratings, and any information they have added to their Profiles. Riders and Drivers who connect their Shamrock Ride accounts to Facebook will also be able to see their mutual Facebook friends during the ride. Drivers see the pick-up location that the Rider has provided. Riders see a Drivers vehicle information and real-time location as the Driver approaches the pick-up location. Ridersratings of Drivers are shared with Drivers on a weekly basis. We de-identify the ratings and feedback, but we cant rule out that a driver may be able to identify the Rider that provided the rating or feedback. Although we help Riders and Drivers communicate with one another to arrange a pickup, we do not share your actual phone number or other contact information with other Users. If you report a lost or found item to us, we will seek to connect you with the relevant Rider or Driver, including sharing actual contact information with your permission. Sharing Between Shamrock Ride and Third Parties API and Integration Partners.If you connect to the Shamrock Ride Platform through an integration with a third party service, we may share information about your use of the Shamrock Ride Platform with that third party. We may share your information with our third party partners in order to receive additional information about you. We may also share your information with third party partners to create offers that may be of interest to you.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Third Party Services.The Shamrock Ride Platform may allow you to connect with other websites, products, or services that we dont have control over (for example, we may give you the ability to order a food delivery from a restaurant from within the Shamrock Ride app). If you use these services, we will provide the third party with information about you to allow them to provide the service to you (for example, we would give the restaurant your name, phone number and address to drop off the food). We cant speak to the privacy practices of these third parties, and we encourage you to read their privacy policies before deciding whether to use their services.     Service Providers.We work with third party service providers to perform services on our behalf, and we may share your information with such service providers to help us provide the Shamrock Ride Platform, including all of the things described in Section 3 above.     Access Partners.If you participate in an access program and charge a ride to your organizations billing method or credits, we will provide your organizations account holder with information about your use of the Shamrock Ride Platform, including ride details such as date, time, charge, and pick up and drop off locations. If you create a Business Profile, at the end of each ride you will have the option to designate the ride as a business ride. If you do so, and your organization has a corporate account with Shamrock Ride, we may share information about your use of Shamrock Ride Platform with your organization including ride details such as date, time, charge, and region of the trip. If you change organizations, it is your responsibility to update your Business Profile with the new information. (Please remember to check and set your designation settings accordingly.) If you integrate your account with an expense platform (like Concur) we will share the ride details to your expense account.     Other Sharing.We may share your information with third parties in the following cases: While negotiating or in relation to a change of corporate control such as a restructuring, merger or sale of our assets;     If a government authority requests information and we think disclosure is required or appropriate in order to comply with laws, regulations, or a legal process;     With law enforcement officials, government authorities, or third parties if we think doing so is necessary to protect the rights, property, or safety of the Shamrock Ride community, Shamrock Ride, or the public;     To comply with a legal requirement or process, including but not limited to, civil and criminal subpoenas, court orders or other compulsory disclosures.     If you signed up for a promotion with another Users referral or promotion code, with your referrer to let them know about your redemption of or qualification for the promotion;     With our insurance partners to help determine and provide relevant coverage in the event of an incident;     To provide information about the use of the Shamrock Ride Platform to potential business partners in aggregated or de-identified form that cant reasonably be used to identify you; and     Whenever you consent to the sharing.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'OTHER',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Data Security. We are committed to protecting the data of the Shamrock Ride community. Even though we take reasonable precautions to protect your data, no security measures can be 100% secure, and we cannot guarantee the security of your data.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Childrens Privacy.Shamrock Ride is not directed to children, and we dont knowingly collect personal information from children under 13. If we find out that a child under 13 has given us personal information, we will take steps to delete that information. If you believe that a child under the age of 13 has given us personal information, please contact us athelp@ShamrockRide.com.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Changes to Our Privacy Policy.We may make changes to this Privacy Policy from time to time. If we make any material changes, we will let you know through the Shamrock Ride Platform, by email, or other communication. We encourage you to read this Privacy Policy periodically to stay up-to-date about our privacy practices. As long as you use the Shamrock Ride Platform, you are agreeing to this Privacy Policy and any updates we make to it.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'Contact Information.Feel free to contact us at any time with any questions or comments about this Privacy Policy, your personal information, our use and sharing practices, or your consent choices by contactinghelp@ShamrockRide.com.'
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
    child: Text(
    'Cookies',
    style: TextStyle(
    fontWeight: FontWeight.bold
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child: Text(
    'When you visit our sites or use our services or applications, we may use cookies and other similar technologies to collect additional website usage data to help provide you with a better, faster, and safer experience, and for advertising and marketing purposes. Most web browsers automatically accept cookies, but some browsers allow you to decline cookies or alert you when a website it attempting to place a cookie on your computer.'
    ),
    ),
    ),
    ],
    ),
    )
    ],
    ),
    )
    ],
      )
    );
  }

}