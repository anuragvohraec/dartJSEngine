import 'package:symbol_table/symbol_table.dart';
import 'object.dart';
import 'stack.dart';

/**
 * Context are used , to let dart know which stack is currently under processing.
 * JSContext defines what is the current scope
 */
class JSContext {
  final SymbolTable<JsObject> scope;
  final CallStack callStack;

  JSContext(this.scope, this.callStack);

  JSContext createChild() {
    return new JSContext(scope.createChild(), callStack.duplicate());
  }

  JSContext bind(JsObject context) {
    return createChild()..scope.context = context;
  }
}
