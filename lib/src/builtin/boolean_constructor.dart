import 'package:jsengine/jsengine.dart';

class JsBooleanConstructor extends JsConstructor {
  static JsBooleanConstructor singleton;

  factory JsBooleanConstructor(JsObject context) =>
      singleton ??= new JsBooleanConstructor._(context);

  JsBooleanConstructor._(JsObject context) : super(context, constructor) {
    name = 'Boolean';
    prototype.addAll({
      'constructor': this,
      'toString':
          wrapFunction(JsBooleanConstructor.toString_, context, 'toString'),
      'valueOf':
          wrapFunction(JsBooleanConstructor.valueOf_, context, 'valueOf'),
    });
  }

  static JsObject constructor(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    var first = arguments.getProperty(0.0, jsengine, ctx);

    if (first == null) {
      return new JsBoolean(false);
    } else {
      return new JsBoolean(first.isTruthy);
    }
  }

  static JsObject toString_(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    var v = ctx.scope.context;
    return coerceToBoolean(v, (b) {
      //print('WTF: ${b.valueOf} from ${v?.properties} (${v}) and ${arguments.valueOf}');
      return new JsString(b.valueOf.toString());
    });
  }

  static JsObject valueOf_(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    return coerceToBoolean(ctx.scope.context, (b) => b);
  }
}
