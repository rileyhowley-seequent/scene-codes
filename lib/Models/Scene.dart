class Scene {
  String title;
  String link;

  Scene(this.title, this.link);

  Map toJson() {
    return {'title': title, 'link': link};
  }
}

String get_thumbnail(String link) {
  link = link.replaceAll(".com", ".com/blobs");

  link += "/thumbnail";

  return link;
}
