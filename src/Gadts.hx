import haxe.ds.*;
import haxe.fp.Pretty;
import haxe.fp.*;
import Proof;
import Std.*;

using Pretty.PrettyExtender;
using List.ListExtender;
using Proof.ProofExtender;
using Option.OptionExtender;

class Gadts {

  public static function types(): Pretty {
    return Pretty.log("

/* N1 < N2 */
enum LT<N1, N2> {
  Z<N> : LT<N, S<N>>; /* N < (N+1) */
  L<N1,N2>(hr: LT<N1,N2>) :  LT<N1, S<N2>>; /* N1 < N2 => N1 < (N2+1) */
}

/* N1 + N2 = N3 */
enum Add<N1, N2, N3> {
  Z<N>() : Add<N, _0, N>; /* N + 0 = N */
  L<N1,N2,N3>(hr: Add<N1, N2, N3>) : Add<N1, S<N2>, S<N3>>; /* N1 + N2 = N3 => N1 + (N2+1) = (N3+1) */
}

/* N1 do not divide N2 */
enum NotDiv<N1, N2> {
  TooBig<N1, N2>(lt: LT<S<N2>, N1>): NotDiv<N1, S<N2>>; /* (N2+1) < N1 => N1 do not divide (N2+1) */
  Sub<N1, N2, N3>(hr: NotDiv<N1, N2>, add: Add<N1, N2, N3>): NotDiv<N1, N3>; /* N1 do not divide N2 => N1 do not divide (N1+N2) */
}

/* ForAll<N1, N2> = For all N, N1 <= N < N2 => N do not divide N2 */
enum ForAll<N1, N2> {
  Empty<N1, N2>(lt: LT<N2, S<N1>>) : ForAll<N1, N2>; /* N2 < (N1+1) => ForAll<N1, N2> */ 
  Cons<N1, N2>(head: NotDiv<N1, N2>, tail: ForAll<S<N1>, N2>) : ForAll<N1, N2>; /* N1 do not divide N2 && ForAll<(N1+1), N2> => ForAll<N1, N2> */
}

/* N is prime if and only if ForAll<2, N> */
typedef Prime<N> = ForAll<_2, N>;

");
  }

  public static function tNats(e: Int): Pretty {

    function list(n: Int): String {
      var s = "String";

      for (i in 0...n)
        s = 'List<$s>';
      
      return s;
    }

    var r: Pretty =
      Pretty.log(
"/*
   Implementation of natural numbers (i.e. non negative integers)
   in the type sytem. Each natural number n is represented by a
   type _n :

   type _n = List<...List<String>> with n occurences of 'List'
  
   The successor operation is the type function List<_>.
*/
typedef S<N> = List<N>;

// We take the type String as Zero (it could be anything apart from List)
typedef _0 = String;
");

    for (n in 1...(e+2))
      r += Pretty.log('typedef _$n = S<_${n-1}>; // ${list(n)}\n');

    return r;
  }

  public static function lt(i: Int, j: Int): Option<Proof> {
    function type(i: Int, j: Int): String {
      return 'LT<_$i, _$j>';
    }

    function z(n : Int): Option<Proof> {
      return Some(Leaf(type(n, n+1), "LT.Z"));
    }

    function l(n1: Int, n2: Int): Option<Proof> {
      return lt(n1, n2).map(function(hr) {
        return Node(type(n1, n2+1), "LT.L", Cons(hr, Nil));
      });
    }

    return
      if (i >= j)
        None
      else if (j == i + 1)
        z(i)
      else
        l(i, j - 1)
    ;
  }

  public static function add(i: Int, j: Int): Option<Proof> {
    function type(i: Int, j: Int): String {
      return 'Add<_$i, _$j, _${i+j}>';
    }

    function z(i: Int): Option<Proof> {
      return Some(Leaf(type(i, 0), "Add.Z"));
    }

    function l(n1: Int, n2: Int): Option<Proof> {
      return add(n1, n2).map(function(hr) {
        return Node(type(n1, n2+1), "Add.L", Cons(hr, Nil));
      });
    }


    return
      if (j < 0 || i < 0)
        None;
      else if (j == 0)
        z(i)
      else
        l(i, j - 1)
      ;
  }

  public static function primeWith(i: Int, j: Int): Option<Proof> {
    function type(i: Int, j: Int): String {
      return 'PrimeWith<_$i, _$j>';
    }

    function oneLeft(n: Int): Option<Proof> {
      return Some(Leaf(type(1, n), "PrimeWith.OneLeft"));
    }

    function sym(n1: Int, n2: Int): Option<Proof> {
      return primeWith(n2, n1).map(function(hr) {
        return Node(type(n1, n2), "PrimeWith.Sym", Cons(hr, Nil));
      });
    }

    function sub(n1: Int, n2: Int): Option<Proof> {
      return primeWith(n1, n2).andThen(function(hr) {
        return add(n1, n2).map(function(sub) {
          return Node(type(n2, n1 + n2), "PrimeWith.Sub", Cons(hr, Cons(sub, Nil)));
        });
      });
    }

    return
      if (i < 0 || j < 0)
        None
      else if (i == 1)
        oneLeft(j)
      else if (i > j || j == 1)
        sym(i, j)
      else if (i != j)
        sub(j - i, i)
      else 
        None
    ;
  }

  public static function notDiv(n1: Int, n2: Int): Option<Proof> {
    // TooBig<N1, N2>(lt: LT<S<N2>, N1>): NotDiv<N1, S<N2>>;
    // Sub<N1, N2, N3>(hr: NotDiv<N1, N2>, add: Add<N1, N2, N3>): NotDiv<N1, N3>;
    function type(i: Int, j: Int): String {
      return 'NotDiv<_$i, _$j>';
    }

    function tooBig(n1: Int, n2: Int): Option<Proof> {
      return lt(n2 + 1, n1).map(function(hr) {
        return Node(type(n1,n2 + 1), "NotDiv.TooBig", Cons(hr, Nil));
      });
    }

    function sub(n1: Int, n2: Int): Option<Proof> {
      return notDiv(n1, n2).andThen(function(hr) {
        return add(n1, n2).map(function(tail) {
          return Node(type(n1,n1 + n2), "NotDiv.Sub", Cons(hr, Cons(tail, Nil)));
        });
      });
    }

    return
      if (n1 < 0 || n2 < 0)
        None
      else if (0 < n2 && n2 < n1)
        tooBig(n1, n2 - 1)
      else
        sub(n1, n2 - n1)
    ;
  }

  public static function forAll(n1: Int, n2: Int): Option<Proof> {
    //  Empty<N1, N2>(lt: GT<S<N1>, N2>) : ForAll<N1, N2>;
    //  Cons<N1, N2>(head: PrimeWith<N1, N2>, tail: ForAll<S<N1>, N2>) : ForAll<N1, N2>;
    function type(i: Int, j: Int): String {
      return 'ForAll<_$i, _$j>';
    }

    function empty(n1: Int, n2: Int): Option<Proof> {
      return lt(n2, n1+1).map(function(hr) {
        return Node(type(n1,n2), "ForAll.Empty", Cons(hr, Nil));
      });
    }

    function cons(n1: Int, n2: Int): Option<Proof> {
      return notDiv(n1, n2).andThen(function(hr) {
        return forAll(n1+1, n2).map(function(tail) {
          return Node(type(n1,n2), "ForAll.Cons", Cons(hr, Cons(tail, Nil)));
        });
      });
    }

    return
      if (n1 >= n2)
        empty(n1, n2)
      else
        cons(n1, n2)
    ;
  }

  public static function prime(n: Int): Option<Proof> {
    return forAll(2, n);
  }

  public static function renderMain(n: Int): Void {
    var content : Pretty =
      tNats(n) +
      types() +
      Pretty.log('\n\nclass Prime$n {\n  ') +
      PrettyTools.block(
        Pretty.log('public static var prime$n : Prime<_$n> =\n  ') +
        PrettyTools.block(
          (switch prime(n) {
            case Some(p): p.print();
            case None: Pretty.log("null");
          }) + Pretty.log(";")
        ) +
        Pretty.log('\n\npublic static function main(): Void {\n  Sys.print(\'$$prime$n\');\n}')
      ) +
      Pretty.log("\n}")
    ;

    sys.io.File.saveContent('Prime$n.hx',content.run());
  }

  public static function arg(): Option<Int> {
    var args: Array<String> =
      Sys.args();

    return 
      if (args.length >= 1) {
        var n : Null<Int> = Std.parseInt(args[0]);
        if (n == null)
          None;
        else
          Some(n);
      } else None
    ;
  }

  public static function render(o : Option<Proof>): String {
    return switch(o) {
      case None: "Error";
      case Some(p): p.print().run();
    };
  }

  public static function main(): Void {
    switch (arg()) {
      case Some(p):
        renderMain(p);
      case None:
        trace("Usage: Gadts <a positive integer>");
    };
  }
}