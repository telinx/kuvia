import 'dart:async';

import 'package:kuvia/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kuvia/image_extended/extended_image.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'dart:math';

class ImageGallery extends StatefulWidget {

  ImageGallery({Key key, this.index = 0, @required this.imageList}) : super(key: key);
  
  //  默认从第一张（index = 0）开始看起 
  final int index; 
  final List imageList;

  @override
  _ImageGalleryStatus createState() => _ImageGalleryStatus();
}

class _ImageGalleryStatus extends State<ImageGallery> with SingleTickerProviderStateMixin {

  var rebuildIndex = StreamController<int>.broadcast();
  var rebuildSwiper = StreamController<bool>.broadcast();

  AnimationController _animationController;
  Animation<double> _animation;
  Function animationListener;
  
  List<double> doubleTapScales = <double>[1.0, 4.0];

  int currentIndex;
  bool _showSwiper = true;

  TipDialogController tipController;

  @override
  void initState() {
    currentIndex = widget.index;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    rebuildIndex.close();
    rebuildSwiper.close();
    _animationController?.dispose();
    clearGestureDetailsCache();
    //cancelToken?.cancel();
    super.dispose();
  }
  
  double _initalScale({Size imageSize, Size size, double initialScale}) {
    var n1 = imageSize.height / imageSize.width;
    var n2 = size.height / size.width;
    if (n1 > n2) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      Size destinationSize = fittedSizes.destination;
      return size.width / destinationSize.width;
    } else if (n1 / n2 < 1 / 4) {
      final FittedSizes fittedSizes =
          applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      Size destinationSize = fittedSizes.destination;
      return size.height / destinationSize.height;
    }

    return initialScale;
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.v("opening image gallery widget");

    Size size = MediaQuery.of(context).size;

    Widget imageSliderFadeOut = Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                String itemUrl = widget.imageList[index];
                Widget image = ExtendedImage.network(
                  "$itemUrl",
                  fit: BoxFit.contain,
                  enableSlideOutPage: true, // 是否开启滑动退出
                  mode: ExtendedImageMode.Gesture,
                  initGestureConfigHandler: (state) {
                    double initialScale = 1.0;

                    LogUtil.v("width: ${state.extendedImageInfo.image.width.toDouble()} ${AppConfig.appScreenWidth}");
                    LogUtil.v("height: ${state.extendedImageInfo.image.height.toDouble()}");

                    if (state.extendedImageInfo != null && state.extendedImageInfo.image != null) {
                      initialScale = _initalScale(
                          size: size,
                          initialScale: initialScale,
                          // imageSize: Size(
                          //     state.extendedImageInfo.image.width.toDouble(),
                          //     state.extendedImageInfo.image.height.toDouble()
                          // )
                          imageSize: Size(
                              AppConfig.appScreenWidth,
                              AppConfig.appScreenHeight
                          )
                      );
                    }
                    return GestureConfig(
                        inPageView: true,
                        initialScale: initialScale,
                        maxScale: max(initialScale, 5.0),
                        animationMaxScale: max(initialScale, 5.0),
                        //you can cache gesture state even though page view page change.
                        //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                        cacheGesture: false
                    );
                  },
                  // 双击放大
                  onDoubleTap: (ExtendedImageGestureState state) {
                    ///you can use define pointerDownPosition as you can,
                    ///default value is double tap pointer down postion.
                    var pointerDownPosition = state.pointerDownPosition;
                    double begin = state.gestureDetails.totalScale;
                    double end;

                    //remove old
                    _animation?.removeListener(animationListener);

                    //stop pre
                    _animationController.stop();

                    //reset to use
                    _animationController.reset();

                    if (begin == doubleTapScales[0]) {
                      end = doubleTapScales[1];
                    } else {
                      end = doubleTapScales[0];
                    }

                    animationListener = () {
                      //print(_animation.value);
                      state.handleDoubleTap(
                          scale: _animation.value,
                          doubleTapPosition: pointerDownPosition);
                    };
                    _animation = _animationController
                        .drive(Tween<double>(begin: begin, end: end));

                    _animation.addListener(animationListener);

                    _animationController.forward();
                  },
                  //长按保存
                  onLongPress:(){
                    // final ThemeData theme = Theme.of(context);
                    LogUtil.v('_handleLongPress---+++++++++++++==->>>>');
                    // const TextStyle tipStyle = TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400);

                    showModalBottomSheet(
                      backgroundColor : Colors.transparent,
                      context: context,
                      builder: (builder) {
                        return SafeArea(
                          bottom: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                            child : Container(
                              width: double.infinity,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.white
                              ),
                              child: ListView(
                                children: List.generate(
                                  1,
                                  (index) {
                                    return Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            try{
                                              saveNetworkImageToPhoto(widget.imageList[currentIndex]).then((bool done) {
                                                LogUtil.v('tipDialogController------------->>>>$tipController');
                                                tipController.show(
                                                  tipDialog: TipDialog(
                                                    type: TipDialogType.SUCCESS,
                                                    tip: 'Saved Success',
                                                  ),
                                                  isAutoDismiss: true
                                                );
                                                LogUtil.v('Saved Success');
                                                Navigator.pop(context, 'Success');
                                                // Fluttertoast.showToast(
                                                //     msg: "Success Saved",
                                                //     toastLength: Toast.LENGTH_SHORT,
                                                //     gravity: ToastGravity.CENTER,
                                                //     timeInSecForIos: 1,
                                                //     backgroundColor: Colors.black26,
                                                //     textColor: Colors.white,
                                                //     fontSize: 13.0
                                                // );
                                                
                                              });
                                            } catch(e){
                                              Navigator.pop(context, 'Failed');
                                              tipController.show(
                                                tipDialog: TipDialog(
                                                  type: TipDialogType.FAIL,
                                                  tip: 'Save Failed',
                                                ),
                                                isAutoDismiss: true
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 50.0,
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Save Photo",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context).textTheme.title.color
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(top : BorderSide(width: 5, color: AppConfig.placeHolderColor))
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context).textTheme.subhead.color
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                ),
                              ),
                            )
                          ),
                        );
                    });

                    // showCupertinoModalPopup<String>(
                    //   context: context,
                    //   builder: (context) => CupertinoActionSheet(
                    //       // title: const Text('Save Photo'),
                    //       // message: Text('', style: dialogTextStyle),
                    //       actions: <Widget>[
                    //         CupertinoActionSheetAction(
                    //           child: const Text('Save Photo', style: tipStyle,),
                    //           onPressed: () {
                    //             try{
                    //               saveNetworkImageToPhoto(widget.imageList[currentIndex]).then((bool done) {
                    //                 Navigator.pop(context, 'Success');
                    //                 LogUtil.v('Saved Success');
                    //                 // Fluttertoast.showToast(
                    //                 //     msg: "Success Saved",
                    //                 //     toastLength: Toast.LENGTH_SHORT,
                    //                 //     gravity: ToastGravity.CENTER,
                    //                 //     timeInSecForIos: 1,
                    //                 //     backgroundColor: Colors.black26,
                    //                 //     textColor: Colors.white,
                    //                 //     fontSize: 13.0
                    //                 // );
                    //                 LogUtil.v('tipDialogController------------->>>>$tipController');
                    //                 tipController.show(
                    //                   tipDialog: TipDialog(
                    //                     type: TipDialogType.SUCCESS,
                    //                     tip: 'Saved Success',
                    //                   ),
                    //                   isAutoDismiss: true
                    //                 );
                    //               });
                    //             }catch(e){
                    //               Navigator.pop(context, 'Failed');
                    //               tipController.show(
                    //                 tipDialog: TipDialog(
                    //                   type: TipDialogType.FAIL,
                    //                   tip: 'Save Failed',
                    //                 ),
                    //                 isAutoDismiss: true
                    //               );
                    //             }
                    //           },
                    //         ),
                    //       ],
                    //       cancelButton: CupertinoActionSheetAction(
                    //         child: const Text('Cancel', style: tipStyle,),
                    //         isDefaultAction: true,
                    //         onPressed: () {
                    //           Navigator.pop(context, 'Cancel');
                    //         },
                    //       )
                    //     )
                    //   );
                  }
                );

                if (index == currentIndex) {
                  // return Hero(
                  //   tag: widget.imageList[index],
                  //   child: image,
                  // );
                  return image;
                } else {
                  return image;
                }
              },
              itemCount: widget.imageList.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
                rebuildIndex.add(index);
              },
              controller: PageController(
                initialPage: currentIndex,
              ),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              //physics: ClampingScrollPhysics(),
            ),
            StreamBuilder<bool>(
              builder: (c, d) {
                if (d.data == null || !d.data) return Container();

                return SafeArea(
                  child: Stack(
                    children: <Widget>[

                      Positioned(
                        top: 12,
                        right: 10.0,
                        child: CloseFloatButtom(
                          theme: 'dark',
                          clickPadding : 0,
                        ),
                      ),

                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                          child: BottomSwiperText(widget.imageList, currentIndex, rebuildIndex, tipController),
                        ),
                      )
                      
                    ],
                  ),
                );

                
              },
              initialData: true,
              stream: rebuildSwiper.stream,
            )
          ]
        );
            

    return ExtendedImageSlidePage(
      child: TipDialogConnector(builder: (context, tipController){
        this.tipController = tipController;
        return imageSliderFadeOut;
      }),
      resetPageDuration	: const Duration(milliseconds: 200),
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      onSlidingPage: (state) {
        ///you can change other widgets' state on page as you want
        ///base on offset/isSliding etc
        //var offset= state.offset;
        var showSwiper = !state.isSliding;
        if (showSwiper != _showSwiper) {
          // do not setState directly here, the image state will change,
          // you should only notify the widgets which are needed to change
          // setState(() {
          // _showSwiper = showSwiper;
          // });

          _showSwiper = showSwiper;
          rebuildSwiper.add(_showSwiper);
        }
      },
    );
    
      
  }
}



class BottomSwiperText extends StatelessWidget {
  final List imageList;
  final int index;
  final StreamController<int> reBuild;
  final TipDialogController tipController;
  
  BottomSwiperText(this.imageList, this.index, this.reBuild, this.tipController);

  @override
  Widget build(BuildContext context) {

    return TipDialogConnector(
      builder: (context, tipController){
        
        return StreamBuilder<int>(
          builder: (BuildContext context, data) {
            return DefaultTextStyle(
              style: TextStyle(color: Colors.blue),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50.0,
                  // color: Colors.black.withOpacity(0.2),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${data.data + 1}",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.title.color,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            "/${imageList.length}",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle.color,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),

                      // GestureDetector(
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     child: Icon(
                      //       Icons.save,
                      //       size: 26.0,
                      //       color: Colors.black.withOpacity(0.6),
                      //       semanticLabel : "Saved"
                      //     ),
                      //     // Text(
                      //     //   "Save",
                      //     //   style: TextStyle(fontSize: 16.0, color: Colors.blue),
                      //     // ),
                      //   ),
                      //   onTap: () {
                      //     saveNetworkImageToPhoto(imageList[index])
                      //         .then((bool done) {
                      //           LogUtil.v('Saved Success');
                      //           tipController.show(
                      //             tipDialog: TipDialog(
                      //               type: TipDialogType.SUCCESS,
                      //               tip: 'Saved Success',
                      //             ),
                      //             isAutoDismiss: true
                      //           );
                      //     });
                      //   },
                      // )

                    ],
                  ),
                ),
              );
            },
            initialData: index,
            stream: reBuild.stream,
          );
      }
    );
    
    
    
  }
}

///save netwrok image to photo
Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
  var data = await getNetworkImageData(url, useCache: useCache);
  var filePath = await ImagePickerSaver.saveFile(fileData: data);
  return filePath != null && filePath != "";
}