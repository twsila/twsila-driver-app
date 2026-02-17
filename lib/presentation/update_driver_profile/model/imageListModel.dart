import 'dart:io';

enum ImageLoadingModel {
  NETWORK,FILE
}

class ImageListModel{
  ImageLoadingModel imageListModel;
  List<File> filesList;
  List<String> imageUrls;

  ImageListModel(this.imageListModel, this.filesList, this.imageUrls);
}
