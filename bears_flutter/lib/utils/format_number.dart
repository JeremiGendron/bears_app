final RegExp _badMatch = RegExp(r'\.0(K|M|B)');

String formatNumber(int value) {
  final int digitCount = value.toString().length;
  if (digitCount < 4) return value.toString();
  
  final List<String> digits = value.toString().split('');

  String result;

  switch (digitCount) {
    case 4:
      result = "${digits[0]}.${digits[1]}K";
      break;
    case 5:
      result = "${digits[0]}${digits[1]}K";
      break;
    case 6:
      result = "${digits[0]}${digits[1]}${digits[2]}K";
      break;
    case 7:
      result = "${digits[0]}.${digits[1]}M";
      break;
    case 8:
      result = "${digits[0]}${digits[1]}M";
      break;
    case 9:
      result = "${digits[0]}${digits[1]}${digits[2]}M";
      break;
    case 10:
      result = "${digits[0]}.${digits[1]}B"; 
      break;
  }

  if (_badMatch.hasMatch(result)) {
    List<String> characters = result.split('');
    String unit = characters.last;
    characters = characters.sublist(0, characters.length - 3)..add(unit);

    result = characters.join('');
  }

  return result;
}