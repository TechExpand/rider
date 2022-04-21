import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:riderapps/Language/appLocalizations.dart';
import 'package:riderapps/modules/splash/nice_introduction_screen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  var pageController = PageController(initialPage: 0);
  List<PageViewData> pageViewModelData = [];

  late Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void initState() {
    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Confirm your Driver'),
      subText: AppLocalizations.of('Huge drivers network helps you find a\ncomfortable and cheap ride'),
      assetsImage: 'assets/images/intro_1.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Request Ride'),
      subText: AppLocalizations.of('Request a ride gets picked up by a\nnearby community driver'),
      assetsImage: 'assets/images/intro_2.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Track your ride'),
      subText: AppLocalizations.of('Know your driver in advance and be\nable to view current location in real-time\non the map'),
      assetsImage: 'assets/images/intro_3.png',
    ));

    sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (currentShowIndex == 0) {
        pageController.animateTo(MediaQuery.of(context).size.width, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 1) {
        pageController.animateTo(MediaQuery.of(context).size.width * 2, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 2) {
        pageController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    sliderTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  currentShowIndex = index;
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PagePopup(imageData: pageViewModelData[0]),
                  PagePopup(imageData: pageViewModelData[1]),
                  PagePopup(imageData: pageViewModelData[2]),
                ],
              ),
            ),
            PageViewIndicator(
              length: 3,
              currentIndex: 1,

              // layout: PageIndicatorLayout.WARM,
              // size: 10.0,
              // controller: pageController,
              // space: 5.0,
              // count: 3,
              otherColor: Theme.of(context).dividerColor,
              currentColor: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 32),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).dividerColor,
                      blurRadius: 8,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NiceIntroductionScreen()),
                      );
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of('Get Started!'),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16 + MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

class PagePopup extends StatelessWidget {
  final  imageData;

  const PagePopup({this.imageData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    imageData.assetsImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Text(
                  imageData.titleText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  imageData.subText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class PageViewData {
  final  titleText;
  final  subText;
  final  assetsImage;

  PageViewData({this.titleText, this.subText, this.assetsImage});
}
