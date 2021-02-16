class Category {
  int id;
  String name;
  String description;
  int color;
  categoryMap(){
    var mapping = Map<String, dynamic>();
    mapping["id"] = id;
    mapping["name"] = name;
    mapping["description"] = description;
    mapping["color"] = color;

    return mapping;
  }
}