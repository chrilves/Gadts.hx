package haxe.fp;

import haxe.fp.Prelude.Unit;
import haxe.fp.List;
import haxe.fp.Option;

using Pretty.PositionExtender;
using List.ListExtender;
using Option.OptionExtender;

private enum Position {
  Position(current: Int, offset: Int);
}

class PositionExtender {
  public static function current(p: Position): Int {
    return switch (p) {
      case Position(c, o): c;
    };
  }

  public static function offset(p: Position): Int {
    return switch (p) {
      case Position(c, o): o;
    };
  }

  public static function save(p: Position): Position {
    return switch (p) {
      case Position(c, o): Position(c, c);
    };
  }
}

private enum State {
  State(position: Position, output: String);
}

abstract Pretty(Position -> State) {
  inline public function new(f: Position -> State) {
    this = f;
  }

  public function apply(pos: Position): State {
    return this(pos);
  }

  public function run(): String {
    return switch (this(Position(0, 0))) {
      case State(_,o): o;
    };
  }

  @:op(A + B)
  public function plus(other: Pretty): Pretty {
    return new Pretty(function(pos: Position) {
      return switch (this(pos)) {
               case State(p0, o0): 
                 switch (other.apply(p0)) {
                   case State(p1, o1):
                     State(p1, o0 + o1);
                 };
      };
    });
  }

  public static function empty(): Pretty {
    return new Pretty(function(pos: Position) {
      return State(pos, "");
    });
  }

  public static function newLine(): Pretty {
    return new Pretty(function(pos: Position) {

      var s = "\n";

      for (i in 0...pos.offset())
        s += " ";

      return State(Position(pos.offset(), pos.offset()), s);
    });
  }

  public static function offset(): Pretty {
    return new Pretty(function(pos: Position) {
      return State(pos.save(), "");
    });
  }

  public function local(): Pretty {
    return new Pretty(function(pos: Position) {
      return switch (this(pos)) {
        case State(Position(c,o), s): State(Position(c, pos.offset()), s);
      };
    });
  }

  public function block(): Pretty {
    return new Pretty(function(pos: Position) {
      return switch (this(pos.save())) {
        case State(Position(c,o), s): State(Position(c, pos.offset()), s);
      };
    });
  }

  public static function log(s: String): Pretty {
    return new Pretty(function(pos: Position) {

      // Building the margin    
      var margin = "";
      
      for (i in 0...pos.offset())
        margin += " ";

      // The splits
      var splits = s.split("\n");

      if (splits.length < 1) {
        splits = new Array<String>();
        splits.push(s);
      }
        
      // Output
      var output = splits[0];

      for (i in 1...splits.length)
        output += "\n" + margin + splits[i];

      // New position
      var newPosition: Int =
        if (splits.length > 1)
          pos.offset() + splits[splits.length - 1].length
        else
          pos.current() + splits[0].length;

      return State(Position(newPosition, pos.offset()), output); 
    });
  }
}

class PrettyExtender {
  public static function reduce(l: List<Pretty>, sep: Pretty): Pretty {
    function add(p1: Pretty, p2: Pretty): Pretty {
      return p1 + sep + p2;
    }

    return l.reduceLeft(add).getOrElse(Pretty.empty());
  }
  
  public static function concat(l: List<Pretty>): Pretty {
    return l.foldLeft(Pretty.empty(), function(p1, p2) { return p1 + p2; }) ;
  }
}

class PrettyTools {
  public static function local(p: Pretty): Pretty {
    return p.local();
  }

  public static function block(p: Pretty): Pretty {
    return p.block();
  }
}