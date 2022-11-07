import 'package:rule_engine/rule_engine.dart';

class PondropRules {
  PondropRules() {
    String code = r"""
rule "get amount for bob"
  when
      SimpleFact( name == "Bob", $name: name )
  then
      publish Achievement( "Bob saved some money", $name )
end
rule "get amount for not Bob"
  when
      not SimpleFact( name == "Bob", $name: name )
  then
      publish Achievement( "Not Bob saved some money", $name )
end
""";

    ruleEngine = RuleEngine(code);

    //You can register multiple listeners, which are all called in the order they are registered
    ruleEngine.registerListener((type, arguments) {
      print("insert $type with arguments $arguments");
    });    
  }

  late final RuleEngine ruleEngine;

  void insertFact() {
    //insert a fact that implements from [Fact]
    ruleEngine.insertFact(SimpleFact("Bob", 1000, DateTime.now()));
    ruleEngine.insertFact(SimpleFact("John", 1000, DateTime.now()));
  }
}

class SimpleFact extends Fact {
  final String _name;
  final int _amount;
  final DateTime _created;

  SimpleFact(this._name, this._amount, this._created);

  @override
  Map<String, dynamic> attributeMap() {
    Map<String, dynamic> attributes = {};
    attributes["name"] = _name;
    attributes["amount"] = _amount;
    attributes["created"] = _created;
    return attributes;
  }

  @override
  String toString() {
    return "$_name: $_amount $_created";
  }
}
