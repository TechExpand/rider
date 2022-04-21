import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riderapps/constance/constance.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final  fromAddress;
  final  toAddress;
  final  price;
  final  status;
  final  statusColor;
  final  time;

  const CardWidget(
      {this.fromAddress, this.toAddress, this.price, this.status, this.statusColor, this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ConstanceData.startPin,
                  height: 32,
                  width: 32,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  fromAddress,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme
                        .of(context)
                        .textTheme
                        .headline5
                        ?.color,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 22,
            ),
            child: Container(
              height: 16,
              width: 2,
              color: Theme
                  .of(context)
                  .dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Image.asset(
                  ConstanceData.endPin,
                  height: 30,
                  width: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  toAddress,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      !.copyWith(
                    color: Theme
                        .of(context)
                        .textTheme
                        .headline4
                        ?.color,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8, bottom: 8),
            child: Row(
                children: <Widget>[
            Text('',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  ?.color,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: Theme
                .of(context)
                .textTheme
                .headline4
                !.copyWith(
              color: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  ?.color,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              time,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle1
                  !.copyWith(
                color: statusColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              status,
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle1
                  !.copyWith(
                color: statusColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),]
    ,
    )
    ,
    );
  }
}