import 'package:dartjsengine/dartjsengine.dart';
import 'boolean_constructor.dart';
import 'function_constructor.dart';
import 'misc.dart';

void loadBuiltinObjects(JSEngine jsengine) {
  loadMiscObjects(jsengine);

  jsengine.global.properties.addAll({
    'Boolean': new JsBooleanConstructor(jsengine.global),
    'Function': new JsFunctionConstructor(jsengine.global),
  });
}
