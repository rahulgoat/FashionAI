class Note {
  String outfitName;
  String description;

  Note({required this.outfitName, required this.description});

  factory Note.fromJson(Map<String, dynamic> json) {
    String outfitName = '';
    for (var key in json.keys) {
      if (key.startsWith('Outfit_name')) {
        outfitName = json[key];
        break;
      }
    }

    return Note(
      outfitName: outfitName,
      description: json['description'],
    );
  }
}
