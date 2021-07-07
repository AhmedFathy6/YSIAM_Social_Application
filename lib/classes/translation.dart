import 'package:get/get.dart';
import 'package:social_app/utils/ar.dart';
import 'package:social_app/utils/en.dart';

class Translation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
