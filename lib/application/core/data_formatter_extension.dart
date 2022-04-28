extension DataFormatter on String {
  String limitCharacters(int characterLimit, String overflowReplacement) {
    assert(characterLimit > 0, "The character limit must be a positiv integer");
    assert(overflowReplacement.length < characterLimit, "The replacement String must be shorter to the characterLimit");

    if (length > characterLimit) {
      String newSubString = substring(0, characterLimit - overflowReplacement.length);
      return newSubString + overflowReplacement;
    }
    return this;
  }
}