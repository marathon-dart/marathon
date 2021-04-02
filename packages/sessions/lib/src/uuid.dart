import 'dart:math';

/// Generates a v4 compliant uuid. It uses Dart's Random.secure(), which is
/// provided with a guarantee of cryptographic security.
String genUUID() {
  // Generate random bytes.
  var random = Random.secure();
  var bytes = List<int>.generate(16, (index) => random.nextInt(256));

  var str = _convertToHex(bytes);

  // Concatenate into full UUID.
  return str.substring(0, 8) +
      '-' +
      str.substring(8, 12) +
      '-' +
      str.substring(12, 16).replaceRange(0, 1, '4') +
      '-' +
      str.substring(16, 20).replaceRange(0, 1, '1') +
      '-' +
      str.substring(20);
}

/// Takes a List of bytes (integers < 256) and returns a String encoded in
/// hexadecimal format. This is essentially the same as radix-16, but we have to
/// prepend a zero to lone characters.
String _convertToHex(List<int> bytes) {
  var buffer = StringBuffer();
  for (var part in bytes) {
    buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
  }
  return buffer.toString();
}
