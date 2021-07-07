import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:social_app/shared/component.dart';
import 'package:photo_view/photo_view.dart';

class ViewImagePost extends StatelessWidget {
  final List<String> images;
  const ViewImagePost({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Component.defaultAppBar(
        context: context,
        beforeGoBack: () {},
      ),
      body: Center(
        child: Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
              );
            },
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            itemCount: images.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
