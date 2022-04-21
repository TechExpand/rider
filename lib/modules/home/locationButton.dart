import 'package:flutter/material.dart';
class LocationButtonView extends StatelessWidget {
  final  gpsClick;

  const LocationButtonView({this.gpsClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width > 340 ? 54 : 48,
        height: MediaQuery
            .of(context)
            .size
            .width > 340 ? 54 : 48,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(54.0),
          ),
          child: IconButton(
            icon: Icon(
              Icons.gps_fixed,
              color: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  !.color,
              size: MediaQuery
                  .of(context)
                  .size
                  .width > 340 ? 28 : 26,
            ),
            onPressed: () async {
              try {
                gpsClick();
              } catch (e) {}
            },
          ),
        ),
      ),
    );
  }
}