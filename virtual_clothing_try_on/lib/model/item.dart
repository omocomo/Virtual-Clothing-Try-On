class Item {
  String id;
  int star, review;
  String title, color, price, addition;
  List<dynamic> tag;
  List<dynamic> image, description;

  Item(
    this.id,
    this.star,
    this.tag,
    this.review,
    this.price,
    this.image,
    this.title,
    this.color,
    this.addition,
    this.description
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'star': star,
    'tag': tag,
    'review': review,
    'price': price,
    'image': image,
    'title': title,
    'color': color,
    'addition': addition,
    'description': description,
  };

  static Item fromJson(Map<String, dynamic> json) => Item(
    json['id'],
    json['star'],
    json['tag'],
    json['review'],
    json['price'],
    json['image'],
    json['title'],
    json['color'],
    json['addition'],
    json['description'],
  );

}


