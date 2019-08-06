import 'package:jsparser/jsparser.dart';
import 'package:dartjsengine/dartjsengine.dart';

class JsFunctionConstructor extends JsConstructor {
  static JsFunctionConstructor singleton;

  factory JsFunctionConstructor(JsObject context) =>
      singleton ??= new JsFunctionConstructor._(context);

  JsFunctionConstructor._(JsObject context) : super(context, constructor) {
    name = 'Function';
    prototype.addAll({
      'constructor': this,
      'apply': wrapFunction(JsFunctionConstructor.apply, context, 'apply'),
      'bind': wrapFunction(JsFunctionConstructor.bind_, context, 'bind'),
      'call': wrapFunction(JsFunctionConstructor.call_, context, 'call'),
    });
  }

  static JsObject constructor(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    List<String> paramNames;
    Program body;

    if (arguments.valueOf.isEmpty) {
      paramNames = <String>[];
    } else {
      paramNames = arguments.valueOf.length <= 1
          ? <String>[]
          : arguments.valueOf
              .take(arguments.valueOf.length - 1)
              .map((o) => coerceToString(o, jsengine, ctx))
              .toList();
      body = parsejs(arguments.valueOf.isEmpty
          ? ''
          : coerceToString(arguments.valueOf.last, jsengine, ctx));
    }

    var f = new JsFunction(ctx.scope.context, (jsengine, arguments, ctx) {
      ctx = ctx.createChild();

      for (int i = 0; i < paramNames.length; i++) {
        ctx.scope.create(
          paramNames[i],
          value: arguments.getProperty(i.toDouble(), jsengine, ctx),
        );
      }

      return body == null
          ? null
          : jsengine.visitProgram(body, 'anonymous function', ctx);
    });

    f.closureScope = jsengine.globalScope.createChild()
      ..context = jsengine
          .global; // Yes, this is the intended semantics. Operates in the global scope.
    return f;
  }

  static JsObject apply(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    return coerceToFunction(arguments.getProperty(0.0, jsengine, ctx), (f) {
      var a1 = arguments.getProperty(1.0, jsengine, ctx);
      var args = a1 is JsArray ? a1.valueOf : <JsObject>[];
      return jsengine.invoke(f, args, ctx);
    });
  }

  static JsObject bind_(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    return coerceToFunction(arguments.getProperty(0.0, jsengine, ctx),
        (f) => f.bind(arguments.getProperty(1.0, jsengine, ctx) ?? ctx.scope.context));
  }

  static JsObject call_(
      JSEngine jsengine, JsArguments arguments, JSContext ctx) {
    return coerceToFunction(arguments.getProperty(0.0, jsengine, ctx), (f) {
      return jsengine.invoke(f, arguments.valueOf.skip(1).toList(), ctx);
    });
  }
}
