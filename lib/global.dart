import 'package:riderapps/modules/datamodels/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

String serverKey = 'key=AAAAx7jbmW4:APA91bGf0c0hE7okJFTN_cURtg0G2akcvdt4bLZ9wyCUZb8SviBbn98q5W021Uj3j_2YvlHidp0_cgYx6PZFHkbtXke-evqp7YFylmMeckqdLFYsl7o9VflcpC6sLVt-EkRvIL9RCvwe';
String mapKey = 'AIzaSyCH1M_2GJ66XvaE0s5xsc7GGgEtUU2v4kQ';
//AIzaSyCGDOgE33dc-6UHtIAptXSAVZRogFvV8Hs
final CameraPosition googlePlex = CameraPosition(
target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,);
late User currentFirebaseUser;

late UserP currentUserInfo;