import 'package:jsparser/jsparser.dart';
import 'package:jsengine/jsengine.dart';

main() {
  var jsengine = new JSEngine();

  var program = parsejs("""
  function Car(make, model, year) {
  this.make = make;
  this.model = model;
  this.year = year;
}

Car.prototype.info = function(i) {
  return i+' You are driving a ' + this.year + ' ' + this.make + ' ' + this.model + '.';
};

  var car1 = new Car('Eagle', 'Talon TSi', 1993);
  """, filename: 'car.js');

  jsengine.visitProgram(program);

  for(var i =0 ; i< 100000; i++){
    var program2 = parsejs("""car1.info($i);""",filename: "test.js");
    var result = jsengine.visitProgram(program2);
    print('$i ${result?.valueOf}');
  }

}


