class Item {
  String id;
  final int star, review;
  final String image, title, color, price, addition, description;

  Item({
    this.id = '', 
    required this.star, 
    required this.review, 
    required this.price, 
    required this.image, 
    required this.title, 
    required this.color, 
    required this.addition, 
    required this.description
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'star': star,
    'review': review,
    'price': price,
    'image': image,
    'title': title,
    'color': color,
    'addition': addition,
    'description': description,
  };

  static Item fromJson(Map<String, dynamic> json) => Item(
    id: json['id'],
    star: json['star'],
    review: json['review'],
    price: json['price'],
    image: json['image'],
    title: json['title'],
    color: json['color'],
    addition: json['addition'],
    description: json['description'],
  );

}


