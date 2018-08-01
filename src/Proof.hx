import haxe.fp.List;
import haxe.fp.Pretty;

using haxe.fp.Pretty.PrettyExtender;
using haxe.fp.List.ListExtender;

enum Proof {
  Leaf(type: String, text: String);
  Node(type: String, label: String, children: List<Proof>);
}

class ProofExtender {
  public static function print(p: Proof): Pretty {
    return switch (p) {
      case Leaf(t, s): Pretty.log('($s : $t)');
      case Node(t, l,c):
        if (c.isEmpty())
          print(Leaf(t, l))
        else
          (Pretty.offset() +
           Pretty.log('($l( /* : $t */\n    ') +
           (Pretty.offset() +
            c.map(function(p) { return print(p); })
             .reduce(Pretty.log(",\n"))
           ).local() +
           Pretty.log('\n  ) : $t)')
          ).local();
    };
  }
}
