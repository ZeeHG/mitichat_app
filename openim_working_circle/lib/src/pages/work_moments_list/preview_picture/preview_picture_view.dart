import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

class PreviewPicturePage extends StatefulWidget {
  const PreviewPicturePage({
    super.key,
    required this.metas,
    required this.currentIndex,
    this.heroTag,
  });

  final List<Metas> metas;
  final int currentIndex;
  final String? heroTag;

  @override
  State<PreviewPicturePage> createState() => _PreviewPicturePageState();
}

class _PreviewPicturePageState extends State<PreviewPicturePage> {
  GlobalKey<ExtendedImageSlidePageState> slidePageKey =
      GlobalKey<ExtendedImageSlidePageState>();
  int _pages = 0;

  @override
  void initState() {
    _pages = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        final url = widget.metas.elementAt(_pages).original!;
        IMViews.openDownloadSheet(
          url,
          onDownload: () => HttpUtil.saveUrlPicture(url),
        );
      },
      child: ExtendedImageSlidePage(
        key: slidePageKey,
        slideAxis: SlideAxis.vertical,
        slidePageBackgroundHandler: (offset, pageSize) =>
            defaultSlidePageBackgroundHandler(
          color: Colors.black,
          offset: offset,
          pageSize: pageSize,
        ),
        child: widget.heroTag != null
            ? SlideHeroWidget(
                tag: widget.heroTag!,
                slidePagekey: slidePageKey,
                child: _childView,
              )
            : _childView,
      ),
    );
  }

  Widget get _childView => ExtendedImageGesturePageView.builder(
        itemBuilder: (BuildContext context, int index) {
          var meta = widget.metas.elementAt(index);
          return ExtendedImage.network(
            meta.original!,
            // width: width,
            // height: height,
            fit: BoxFit.fitWidth,
            mode: ExtendedImageMode.gesture,
            enableSlideOutPage: true,
            handleLoadingProgress: false,
            initGestureConfigHandler: (ExtendedImageState state) {
              return GestureConfig(
                inPageView: true,
                initialScale: 1.0,
                maxScale: 5.0,
                animationMaxScale: 6.0,
                initialAlignment: InitialAlignment.center,
              );
            },
            cache: true,
            clearMemoryCacheWhenDispose: false,
            clearMemoryCacheIfFailed: false,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  {
                      return ExtendedImage.network(
                        meta.original!.thumbnailAbsoluteString,
                        // "https://bkqsimg.ikafan.com/upload/image/2017/05/10/1494426013836161.png",
                        cache: true,
                        fit: BoxFit.fitWidth,
                      );
                    final ImageChunkEvent? loadingProgress =
                        state.loadingProgress;
                    final double? progress =
                        loadingProgress?.expectedTotalBytes != null
                            ? loadingProgress!.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null;
                    // CupertinoActivityIndicator()
                    return SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: Center(
                        child: SizedBox(
                          width: 15.0,
                          height: 15.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress,
                          ),
                        ),
                      ),
                    );
                  }
                case LoadState.completed:
                  return null;
                case LoadState.failed:
                  // remove memory cached
                  state.imageProvider.evict();
                  return ImageRes.pictureError.toImage;
              }
            },
          );
        },
        itemCount: widget.metas.length,
        onPageChanged: (int index) {
          _pages = index;
        },
        controller: ExtendedPageController(
          initialPage: widget.currentIndex,
          // pageSpacing: 50,
        ),
      );
}

// class PreviewPicturePage extends StatelessWidget {
//
//   const PreviewPicturePage({
//     super.key,
//     required this.metas,
//     required this.currentIndex,
//     this.heroTag,
//   });
//
//   final List<Metas> metas;
//   final int currentIndex;
//   final String? heroTag;
//
//   @override
//   Widget build(BuildContext context) {
//     return ExtendedImageSlidePage(
//       slideAxis: SlideAxis.vertical,
//       slidePageBackgroundHandler: (offset, pageSize) =>
//           defaultSlidePageBackgroundHandler(
//         color: Colors.black,
//         offset: offset,
//         pageSize: pageSize,
//       ),
//       child:
//           heroTag != null ? Hero(tag: heroTag!, child: _childView) : _childView,
//     );
//   }
//
//   Widget get _childView => ExtendedImageGesturePageView.builder(
//         itemBuilder: (BuildContext context, int index) {
//           var meta = metas.elementAt(index);
//           return ExtendedImage.network(
//             meta.original!,
//             // width: width,
//             // height: height,
//             fit: BoxFit.contain,
//             mode: ExtendedImageMode.gesture,
//             enableSlideOutPage: true,
//             handleLoadingProgress: true,
//             initGestureConfigHandler: (ExtendedImageState state) {
//               return GestureConfig(
//                 inPageView: true,
//                 initialScale: 1.0,
//                 maxScale: 5.0,
//                 animationMaxScale: 6.0,
//                 initialAlignment: InitialAlignment.center,
//               );
//             },
//             cache: true,
//             clearMemoryCacheWhenDispose: false,
//             clearMemoryCacheIfFailed: true,
//             loadStateChanged: (ExtendedImageState state) {
//               switch (state.extendedImageLoadState) {
//                 case LoadState.loading:
//                   {
//                     final ImageChunkEvent? loadingProgress =
//                         state.loadingProgress;
//                     final double? progress =
//                         loadingProgress?.expectedTotalBytes != null
//                             ? loadingProgress!.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null;
//                     // CupertinoActivityIndicator()
//                     return SizedBox(
//                       width: 15.0,
//                       height: 15.0,
//                       child: Center(
//                         child: SizedBox(
//                           width: 15.0,
//                           height: 15.0,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 1.5,
//                             value: progress,
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 case LoadState.completed:
//                   return null;
//                 case LoadState.failed:
//                   // remove memory cached
//                   state.imageProvider.evict();
//                   return null;
//               }
//             },
//           );
//         },
//         itemCount: metas.length,
//         onPageChanged: (int index) {},
//         controller: ExtendedPageController(
//           initialPage: currentIndex,
//           // pageSpacing: 50,
//         ),
//       );
// }
