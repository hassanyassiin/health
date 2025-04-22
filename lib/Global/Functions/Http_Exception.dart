class C_Http_Exception implements Exception {
  final String message;

  C_Http_Exception(this.message);

  @override
  String toString() {
    return message;
  }
}
