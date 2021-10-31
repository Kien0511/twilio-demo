class ReactionAttribute {
  Reactions? reactions;

  ReactionAttribute({this.reactions});

  ReactionAttribute.fromJson(Map<String, dynamic> json) {
    reactions = json['reactions'] != null
        ? new Reactions.fromJson(json['reactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reactions != null) {
      data['reactions'] = this.reactions?.toJson();
    }
    return data;
  }
}

class Reactions {
  List<String>? laugh;
  List<String>? thumbsUp;
  List<String>? heart;
  List<String>? sad;
  List<String>? pouting;
  List<String>? thumbsDown;

  Reactions(
      {this.laugh,
        this.thumbsUp,
        this.heart,
        this.sad,
        this.pouting,
        this.thumbsDown});

  Reactions.fromJson(Map<String, dynamic> json) {
    laugh = json['laugh']?.cast<String>();
    thumbsUp = json['thumbs_up']?.cast<String>();
    heart = json['heart']?.cast<String>();
    sad = json['sad']?.cast<String>();
    pouting = json['pouting']?.cast<String>();
    thumbsDown = json['thumbs_down']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['laugh'] = this.laugh;
    data['thumbs_up'] = this.thumbsUp;
    data['heart'] = this.heart;
    data['sad'] = this.sad;
    data['pouting'] = this.pouting;
    data['thumbs_down'] = this.thumbsDown;
    return data;
  }
}

class Reaction {
  static const String reactionHeart = "❤";
  static const String reactionLaugh = "😂";
  static const String reactionSad = "😥";
  static const String reactionPouting = "😡";
  static const String reactionThumbsUp = "👍";
  static const String reactionThumbsDown = "👎";
}