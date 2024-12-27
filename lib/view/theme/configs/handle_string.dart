class HandleString {
  String SplitString(String string) {
    String originalString = string;
    String newString = "";
    if (string.length >= 27) {
      newString = originalString.substring(0, 15) + '...';
    } else {
      return originalString;
    }
    return newString;
  }

  String SplitEmail(String string) {
    String originalString = string;
    String newString = "";
    if (string.length >= 27) {
      newString = originalString.substring(0, 26) + '...';
    } else {
      return originalString;
    }
    return newString;
  }
}
