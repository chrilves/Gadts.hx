package haxe.fp;

typedef Option<A> = haxe.ds.Option<A>

class OptionExtender {
  public static function map<A,B>(self: Option<A>, f : A -> B): Option<B>
    return switch (self) {
      case None: None;
      case Some(v): Some(f(v));
    }

  public static function andThen<A, B>(self: Option<A>, f: A -> Option<B>): Option<B>
    return switch (self) {
      case None: None;
      case Some(v): f(v);
    }

  public static function ap<A, B>(self: Option<A -> B>, arg: Option<A>): Option<B>
    return switch ([self, arg]) {
      case [Some(f), Some(v)]: Some(f(v));
      case _: None;
    }

  public static function getOrElse<A>(self: Option<A>, dflt: A): A
    return switch (self) {
      case Some(v): v;
      case None: dflt;
    }

  public static function orElse<A>(self: Option<A>, other: Option<A>): Option<A>
    return switch (self) {
      case Some(_): self;
      case None: other;
    }
}