// var orders = [
//   Orders(
//       image: "assets/b1.jpg",
//       name: "Buffalo Wild Wings and 4 items",
//       id: "order1",
//       address: "Can Alegria Paris",
//       total: "\$78.2",
//       date: "10/08/2020 20:20"),
//   Orders(
//       image: "assets/b2.jpg",
//       name: "Carl’s Jr. and 3 items",
//       id: "order2",
//       address: "Le Basilic",
//       total: "\$128.2",
//       date: "10/08/2020 20:20"),
//   Orders(
//       image: "assets/b3.jpg",
//       name: "Chick-Fil-A and 1 item",
//       id: "order3",
//       address: "Can Alegria Paris",
//       total: "\$56.3",
//       date: "11/08/2020 20:20"),
//   Orders(
//       image: "assets/b4.jpg",
//       name: "Cracker Barrel and 2 item",
//       id: "order4",
//       address: "Le Bouclard - Paris 18ème",
//       total: "\$66.3",
//       date: "11/08/2020 20:20"),
// ];

class Orders {
  final String? id;
  final String? image;
  final String? name;
  final String? address;
  final String? total;
  final String? date;
  final String? payment;
  final String? status;
  Orders(
      {this.image,
      this.name,
      this.address,
      this.id,
      this.total,
      this.date,
      this.payment,
      this.status});
}
