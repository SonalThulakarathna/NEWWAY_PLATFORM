class Cardcontent {
  String title;
  String subtitle;
  String author;
  String imagepath;
  String members;
  String price;

  Cardcontent({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.imagepath,
    required this.members,
    required this.price,
  });
  String get ctitle => title;
}
