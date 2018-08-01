package haxe.fp;

enum Unit { Unit; }

class FunExtender {
  public static function apply<A,B>(a: A, f: A -> B): B { return f(a); }
}

class Prelude {

}