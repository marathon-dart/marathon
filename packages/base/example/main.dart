import 'package:marathon/marathon.dart';

void main() async {
  var router = Router();

  await serve(router, 'localhost', 8080);
}
