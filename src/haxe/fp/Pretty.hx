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
  inline final public static function current(p: Position): Int
    return switch (p) {
      case Position(c, o): c;
    }

  inline final public static function offset(p: Position): Int
    return switch (p) {
      case Position(c, o): o;
    }

  inline final public static function save(p: Position): Position
    return switch (p) {
      case Position(c, o): Position(c, c);
    }
}

private enum State {
  State(position: Position, output: String);
}

abstract Pretty(Position -> State) {
  inline final public function new(f: Position -> State) {
    this = f;
  }

  inline final public function apply(pos: Position): State
    return this(pos);

  inline final public function run(): String
    return switch (this(Position(0, 0))) {
      case State(_,o): o;
    }

  @:op(A + B)
  final public function plus(other: Pretty): Pretty
    return new Pretty((pos: Position) ->
      switch (this(pos)) {
        case State(p0, o0): 
          switch (other.apply(p0)) {
            case State(p1, o1):
              State(p1, o0 + o1);
          }
      }
    );

  public static final empty: Pretty =
    new Pretty((pos: Position) -> State(pos, ""));

  public static final newLine: Pretty =
    new Pretty(function(pos: Position) {

      var s = "\n";

      for (i in 0...pos.offset())
        s += " ";

      return State(Position(pos.offset(), pos.offset()), s);
    });

  public static final offset: Pretty =
    new Pretty((pos: Position) -> State(pos.save(), ""));

  public final function local(): Pretty
    return new Pretty((pos: Position) ->
      switch (this(pos)) {
        case State(Position(c,o), s): State(Position(c, pos.offset()), s);
      }
    );

  public final function block(): Pretty
    return new Pretty((pos: Position) ->
      switch (this(pos.save())) {
        case State(Position(c,o), s): State(Position(c, pos.offset()), s);
      }
    );

  public final static function log(s: String): Pretty
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

class PrettyExtender {
  public static function reduce(l: List<Pretty>, sep: Pretty): Pretty {
    function add(p1: Pretty, p2: Pretty): Pretty {
      return p1 + sep + p2;
    }

    return l.reduceLeft(add).getOrElse(Pretty.empty);
  }
  
  inline public static function concat(l: List<Pretty>): Pretty
    return l.foldLeft(Pretty.empty, (p1, p2) -> p1 + p2) ;
}

class PrettyTools {
  inline public static function local(p: Pretty): Pretty
    return p.local();

  inline public static function block(p: Pretty): Pretty
    return p.block();
}