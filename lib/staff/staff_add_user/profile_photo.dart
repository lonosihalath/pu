import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryImageProfile extends StatefulWidget {
  final image;
  const GalleryImageProfile({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _GalleryImageProfileState createState() => _GalleryImageProfileState();
}

class _GalleryImageProfileState extends State<GalleryImageProfile> {
  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Container(
          width: 35,
          child: FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Center(
            child: Container(
          width: screen,
          child: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(color: Colors.white),
              loadingBuilder: (context, event) =>
                  Center(child: CupertinoActivityIndicator(radius: 15,color: Colors.white,)),
              itemCount: 1,
              builder: (context, index) {
                final urlimage = widget.image;
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    urlimage,
                  ),
                );
              }),
        )));
  }
}