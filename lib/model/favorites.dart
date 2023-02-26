class Favorites {
  final String? image;
  final String? text;
  final int? star;
  final String? id;
  Favorites({this.image, this.text, this.star, this.id});
}

var favorites = [
  Favorites(
      image: "assets/pr1.jpg", text: "Interstate Delivery", id: "p1", star: 4),
  Favorites(
      image: "assets/pr2.jpg", text: "Intrastate Delivery", id: "p2", star: 3),
  Favorites(
      image: "assets/pr3.jpg",
      text: "International Courier.",
      id: "p3",
      star: 5),
  Favorites(
      image: "assets/pr4.jpg", text: "Parcel Delivery", id: "p4", star: 5),
];
