//type _n = List<...List<String>> N occurences de 'List'
typedef _0 = String;
typedef S<N> = List<N>;
typedef _1  = S<_0>;
typedef _2  = S<_1>;

enum LT<N1, N2> {
  Z<N> : LT<N, S<N>>;
  L<N1,N2>(hr: LT<N1,N2>) :  LT<N1, S<N2>>;
}

enum Add<N1, N2, N3> {
  Z<N>() : Add<N, _0, N>;
  L<N1,N2,N3>(hr: Add<N1, N2, N3>) : Add<N1, S<N2>, S<N3>>;
}

enum NotDiv<N1, N2> {
  // Si n2 < n1 alors n1 not divide n2
  TooBig<N1, N2>(lt: LT<S<N2>, N1>): NotDiv<N1, S<N2>>;
  Sub<N1, N2, N3>(hr: NotDiv<N1, N2>, add: Add<N1, N2, N3>): NotDiv<N1, N3>;
}

enum PrimeWith<N1, N2> {
  Sym<N1, N2>(hr: PrimeWith<N2, N1>) : PrimeWith<N1, N2>;
  OneLeft<N2> : PrimeWith<_1, N2>;
  Sub<N1, N2, N3>(hr: PrimeWith<N1, N2>, sub: Add<N1, N2, N3>) : PrimeWith<N2, N3>;
}

enum ForAll<N1, N2> {
  Empty<N1, N2>(lt: LT<N2, S<N1>>) : ForAll<N1, N2>;
  Cons<N1, N2>(head: NotDiv<N1, N2>, tail: ForAll<S<N1>, N2>) : ForAll<N1, N2>;
}

typedef Prime<N> = ForAll<_2, N>;