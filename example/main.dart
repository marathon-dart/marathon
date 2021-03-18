import 'package:marathon/marathon.dart';
import 'example_group.dart';

void main() async {
  var router = Router();
  router.register(EchoService());

  await serve(router, 'localhost', 8080); // defined in shelf_io
}
