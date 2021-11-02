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

  Reactions? addReaction(String reactionName, String author) {
    if (reactions == null) {
      reactions = Reactions();
    }
    reactions?.addReaction(reactionName, author);
    return reactions;
  }

  Reactions? removeReaction(String reactionName, String author) {
    reactions?.removeReaction(reactionName, author);
    return reactions;
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

  void addReaction(String reactionName, String author) {
    switch (reactionName) {
      case ReactionName.reactionHeart:
        if (heart == null) {
          heart = [];
        }
        heart?.add(author);
        break;
      case ReactionName.reactionThumbsUp:
        if (thumbsUp == null) {
          thumbsUp = [];
        }
        thumbsUp?.add(author);
        break;
      case ReactionName.reactionLaugh:
        if (laugh == null) {
          laugh = [];
        }
        laugh?.add(author);
        break;
      case ReactionName.reactionSad:
        if (sad == null) {
          sad = [];
        }
        sad?.add(author);
        break;
      case ReactionName.reactionPouting:
        if (pouting == null) {
          pouting = [];
        }
        pouting?.add(author);
        break;
      case ReactionName.reactionThumbsDown:
        if (thumbsDown == null) {
          thumbsDown = [];
        }
        thumbsDown?.add(author);
        break;
    }
  }

  void removeReaction(String reactionName, String author) {
    switch (reactionName) {
      case ReactionName.reactionHeart:
        heart?.remove(author);
        break;
      case ReactionName.reactionThumbsUp:
        thumbsUp?.remove(author);
        break;
      case ReactionName.reactionLaugh:
        laugh?.remove(author);
        break;
      case ReactionName.reactionSad:
        sad?.remove(author);
        break;
      case ReactionName.reactionPouting:
        pouting?.remove(author);
        break;
      case ReactionName.reactionThumbsDown:
        thumbsDown?.remove(author);
        break;
    }
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

class ReactionName {
  static const String reactionHeart = "heart";
  static const String reactionLaugh = "laugh";
  static const String reactionSad = "sad";
  static const String reactionPouting = "pouting";
  static const String reactionThumbsUp = "thumbs_up";
  static const String reactionThumbsDown = "thumbs_down";
}