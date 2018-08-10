package haxe.fp;

import haxe.ds.Option;

using List.ListExtender;

enum List<A> {
  Nil;
  Cons(head: A, tail: List<A>);
}

class ListExtender {
  @:op(A + B)
  public static function append<A>(l1: List<A>, l2: List<A>): List<A>
    return switch (l1) {
      case Nil: l2;
      case Cons(hd, tl): Cons(hd, append(tl, l2));
    }

  public static function isEmpty<A>(l: List<A>): Bool
    return switch (l) {
      case Nil: true;
      case Cons(_, _): false;
    }

  public static function length<A>(l: List<A>): Int
    return switch (l) {
      case Nil: 0;
      case Cons(_, tl): 1 + tl.length();
    }

  public static function pop<A>(s: List<A>): Option<{ head : A, tail: List<A> }>
    return switch (s) {
      case Nil: None;
      case Cons(hd, tl): Some({head: hd, tail: tl });
    }

  public static function map<A,B>(l: List<A>, f: A -> B): List<B>
    return switch (l) {
      case Nil: Nil;
      case Cons(hd, tl): Cons(f(hd), map(tl,f));
    }

  public static function andThen<A,B>(l: List<A>, f: A -> List<B>): List<B>
    return switch (l) {
      case Nil: Nil;
      case Cons(hd, tl): f(hd).append(andThen(tl,f));
    }

  public static function ap<A,B>(l: List<A -> B>, arg: List<A>): List<B>
    return l.andThen((f) ->  arg.map((x) -> f(x)));

  public static function foldLeft<A,B>(l: List<A>, zero: B, add: B -> A ->  B): B
    return switch (l) {
      case Nil: zero;
      case Cons(hd, tl): foldLeft(tl, add(zero, hd), add);
    }

  public static function fold<A,B>(l: List<A>, zero: B, add: A -> B -> B): B
    return switch (l) {
      case Nil: zero;
      case Cons(hd, tl): add(hd, fold(tl, zero, add));
    }

  public static function reduceLeft<A>(l: List<A>, add: A -> A -> A): Option<A>
    return switch (l) {
      case Nil: None;
      case Cons(hd, tl): Some(foldLeft(tl, hd, add));
    }

  public static function reduceRight<A>(l: List<A>, add: A -> A -> A): Option<A>
    return switch (l) {
      case Nil: None;
      case Cons(hd, tl): Some(fold(tl, hd, add));
    }
}