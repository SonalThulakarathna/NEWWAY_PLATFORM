class Cardcontent {
  int id;
  int funnelownerid;
  String title;
  String subtitle;
  String author;
  String imagepath;
  String members;
  String price;
  String condition;
  String userimageurl;
  String profileimageurl;

  Cardcontent(
      {required this.title,
      required this.funnelownerid,
      required this.id,
      required this.subtitle,
      required this.author,
      required this.imagepath,
      required this.members,
      required this.price,
      required this.condition,
      required this.userimageurl,
      required this.profileimageurl});
}
