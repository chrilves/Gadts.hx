/*
   Implementation of natural numbers (i.e. non negative integers)
   in the type sytem. Each natural number n is represented by a
   type _n :

   type _n = List<...List<String>> with n occurences of 'List'
  
   The successor operation is the type function List<_>.
*/
typedef S<N> = List<N>;

// We take the type String as Zero (it could be anything apart from List)
typedef _0 = String;
typedef _1 = S<_0>; // List<String>
typedef _2 = S<_1>; // List<List<String>>
typedef _3 = S<_2>; // List<List<List<String>>>
typedef _4 = S<_3>; // List<List<List<List<String>>>>
typedef _5 = S<_4>; // List<List<List<List<List<String>>>>>
typedef _6 = S<_5>; // List<List<List<List<List<List<String>>>>>>
typedef _7 = S<_6>; // List<List<List<List<List<List<List<String>>>>>>>
typedef _8 = S<_7>; // List<List<List<List<List<List<List<List<String>>>>>>>>
typedef _9 = S<_8>; // List<List<List<List<List<List<List<List<List<String>>>>>>>>>
typedef _10 = S<_9>; // List<List<List<List<List<List<List<List<List<List<String>>>>>>>>>>
typedef _11 = S<_10>; // List<List<List<List<List<List<List<List<List<List<List<String>>>>>>>>>>>
typedef _12 = S<_11>; // List<List<List<List<List<List<List<List<List<List<List<List<String>>>>>>>>>>>>


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



class ProofOfPrime {
  public static var prime11 : Prime<_11> =
    (ForAll.Cons( /* : ForAll<_2, _11> */
        (NotDiv.Sub( /* : NotDiv<_2, _11> */
            (NotDiv.Sub( /* : NotDiv<_2, _9> */
                (NotDiv.Sub( /* : NotDiv<_2, _7> */
                    (NotDiv.Sub( /* : NotDiv<_2, _5> */
                        (NotDiv.Sub( /* : NotDiv<_2, _3> */
                            (NotDiv.TooBig( /* : NotDiv<_2, _1> */
                                (LT.Z : LT<_1, _2>)
                              ) : NotDiv<_2, _1>),
                            (Add.L( /* : Add<_2, _1, _3> */
                                (Add.Z : Add<_2, _0, _2>)
                              ) : Add<_2, _1, _3>)
                          ) : NotDiv<_2, _3>),
                        (Add.L( /* : Add<_2, _3, _5> */
                            (Add.L( /* : Add<_2, _2, _4> */
                                (Add.L( /* : Add<_2, _1, _3> */
                                    (Add.Z : Add<_2, _0, _2>)
                                  ) : Add<_2, _1, _3>)
                              ) : Add<_2, _2, _4>)
                          ) : Add<_2, _3, _5>)
                      ) : NotDiv<_2, _5>),
                    (Add.L( /* : Add<_2, _5, _7> */
                        (Add.L( /* : Add<_2, _4, _6> */
                            (Add.L( /* : Add<_2, _3, _5> */
                                (Add.L( /* : Add<_2, _2, _4> */
                                    (Add.L( /* : Add<_2, _1, _3> */
                                        (Add.Z : Add<_2, _0, _2>)
                                      ) : Add<_2, _1, _3>)
                                  ) : Add<_2, _2, _4>)
                              ) : Add<_2, _3, _5>)
                          ) : Add<_2, _4, _6>)
                      ) : Add<_2, _5, _7>)
                  ) : NotDiv<_2, _7>),
                (Add.L( /* : Add<_2, _7, _9> */
                    (Add.L( /* : Add<_2, _6, _8> */
                        (Add.L( /* : Add<_2, _5, _7> */
                            (Add.L( /* : Add<_2, _4, _6> */
                                (Add.L( /* : Add<_2, _3, _5> */
                                    (Add.L( /* : Add<_2, _2, _4> */
                                        (Add.L( /* : Add<_2, _1, _3> */
                                            (Add.Z : Add<_2, _0, _2>)
                                          ) : Add<_2, _1, _3>)
                                      ) : Add<_2, _2, _4>)
                                  ) : Add<_2, _3, _5>)
                              ) : Add<_2, _4, _6>)
                          ) : Add<_2, _5, _7>)
                      ) : Add<_2, _6, _8>)
                  ) : Add<_2, _7, _9>)
              ) : NotDiv<_2, _9>),
            (Add.L( /* : Add<_2, _9, _11> */
                (Add.L( /* : Add<_2, _8, _10> */
                    (Add.L( /* : Add<_2, _7, _9> */
                        (Add.L( /* : Add<_2, _6, _8> */
                            (Add.L( /* : Add<_2, _5, _7> */
                                (Add.L( /* : Add<_2, _4, _6> */
                                    (Add.L( /* : Add<_2, _3, _5> */
                                        (Add.L( /* : Add<_2, _2, _4> */
                                            (Add.L( /* : Add<_2, _1, _3> */
                                                (Add.Z : Add<_2, _0, _2>)
                                              ) : Add<_2, _1, _3>)
                                          ) : Add<_2, _2, _4>)
                                      ) : Add<_2, _3, _5>)
                                  ) : Add<_2, _4, _6>)
                              ) : Add<_2, _5, _7>)
                          ) : Add<_2, _6, _8>)
                      ) : Add<_2, _7, _9>)
                  ) : Add<_2, _8, _10>)
              ) : Add<_2, _9, _11>)
          ) : NotDiv<_2, _11>),
        (ForAll.Cons( /* : ForAll<_3, _11> */
            (NotDiv.Sub( /* : NotDiv<_3, _11> */
                (NotDiv.Sub( /* : NotDiv<_3, _8> */
                    (NotDiv.Sub( /* : NotDiv<_3, _5> */
                        (NotDiv.TooBig( /* : NotDiv<_3, _2> */
                            (LT.Z : LT<_2, _3>)
                          ) : NotDiv<_3, _2>),
                        (Add.L( /* : Add<_3, _2, _5> */
                            (Add.L( /* : Add<_3, _1, _4> */
                                (Add.Z : Add<_3, _0, _3>)
                              ) : Add<_3, _1, _4>)
                          ) : Add<_3, _2, _5>)
                      ) : NotDiv<_3, _5>),
                    (Add.L( /* : Add<_3, _5, _8> */
                        (Add.L( /* : Add<_3, _4, _7> */
                            (Add.L( /* : Add<_3, _3, _6> */
                                (Add.L( /* : Add<_3, _2, _5> */
                                    (Add.L( /* : Add<_3, _1, _4> */
                                        (Add.Z : Add<_3, _0, _3>)
                                      ) : Add<_3, _1, _4>)
                                  ) : Add<_3, _2, _5>)
                              ) : Add<_3, _3, _6>)
                          ) : Add<_3, _4, _7>)
                      ) : Add<_3, _5, _8>)
                  ) : NotDiv<_3, _8>),
                (Add.L( /* : Add<_3, _8, _11> */
                    (Add.L( /* : Add<_3, _7, _10> */
                        (Add.L( /* : Add<_3, _6, _9> */
                            (Add.L( /* : Add<_3, _5, _8> */
                                (Add.L( /* : Add<_3, _4, _7> */
                                    (Add.L( /* : Add<_3, _3, _6> */
                                        (Add.L( /* : Add<_3, _2, _5> */
                                            (Add.L( /* : Add<_3, _1, _4> */
                                                (Add.Z : Add<_3, _0, _3>)
                                              ) : Add<_3, _1, _4>)
                                          ) : Add<_3, _2, _5>)
                                      ) : Add<_3, _3, _6>)
                                  ) : Add<_3, _4, _7>)
                              ) : Add<_3, _5, _8>)
                          ) : Add<_3, _6, _9>)
                      ) : Add<_3, _7, _10>)
                  ) : Add<_3, _8, _11>)
              ) : NotDiv<_3, _11>),
            (ForAll.Cons( /* : ForAll<_4, _11> */
                (NotDiv.Sub( /* : NotDiv<_4, _11> */
                    (NotDiv.Sub( /* : NotDiv<_4, _7> */
                        (NotDiv.TooBig( /* : NotDiv<_4, _3> */
                            (LT.Z : LT<_3, _4>)
                          ) : NotDiv<_4, _3>),
                        (Add.L( /* : Add<_4, _3, _7> */
                            (Add.L( /* : Add<_4, _2, _6> */
                                (Add.L( /* : Add<_4, _1, _5> */
                                    (Add.Z : Add<_4, _0, _4>)
                                  ) : Add<_4, _1, _5>)
                              ) : Add<_4, _2, _6>)
                          ) : Add<_4, _3, _7>)
                      ) : NotDiv<_4, _7>),
                    (Add.L( /* : Add<_4, _7, _11> */
                        (Add.L( /* : Add<_4, _6, _10> */
                            (Add.L( /* : Add<_4, _5, _9> */
                                (Add.L( /* : Add<_4, _4, _8> */
                                    (Add.L( /* : Add<_4, _3, _7> */
                                        (Add.L( /* : Add<_4, _2, _6> */
                                            (Add.L( /* : Add<_4, _1, _5> */
                                                (Add.Z : Add<_4, _0, _4>)
                                              ) : Add<_4, _1, _5>)
                                          ) : Add<_4, _2, _6>)
                                      ) : Add<_4, _3, _7>)
                                  ) : Add<_4, _4, _8>)
                              ) : Add<_4, _5, _9>)
                          ) : Add<_4, _6, _10>)
                      ) : Add<_4, _7, _11>)
                  ) : NotDiv<_4, _11>),
                (ForAll.Cons( /* : ForAll<_5, _11> */
                    (NotDiv.Sub( /* : NotDiv<_5, _11> */
                        (NotDiv.Sub( /* : NotDiv<_5, _6> */
                            (NotDiv.TooBig( /* : NotDiv<_5, _1> */
                                (LT.L( /* : LT<_1, _5> */
                                    (LT.L( /* : LT<_1, _4> */
                                        (LT.L( /* : LT<_1, _3> */
                                            (LT.Z : LT<_1, _2>)
                                          ) : LT<_1, _3>)
                                      ) : LT<_1, _4>)
                                  ) : LT<_1, _5>)
                              ) : NotDiv<_5, _1>),
                            (Add.L( /* : Add<_5, _1, _6> */
                                (Add.Z : Add<_5, _0, _5>)
                              ) : Add<_5, _1, _6>)
                          ) : NotDiv<_5, _6>),
                        (Add.L( /* : Add<_5, _6, _11> */
                            (Add.L( /* : Add<_5, _5, _10> */
                                (Add.L( /* : Add<_5, _4, _9> */
                                    (Add.L( /* : Add<_5, _3, _8> */
                                        (Add.L( /* : Add<_5, _2, _7> */
                                            (Add.L( /* : Add<_5, _1, _6> */
                                                (Add.Z : Add<_5, _0, _5>)
                                              ) : Add<_5, _1, _6>)
                                          ) : Add<_5, _2, _7>)
                                      ) : Add<_5, _3, _8>)
                                  ) : Add<_5, _4, _9>)
                              ) : Add<_5, _5, _10>)
                          ) : Add<_5, _6, _11>)
                      ) : NotDiv<_5, _11>),
                    (ForAll.Cons( /* : ForAll<_6, _11> */
                        (NotDiv.Sub( /* : NotDiv<_6, _11> */
                            (NotDiv.TooBig( /* : NotDiv<_6, _5> */
                                (LT.Z : LT<_5, _6>)
                              ) : NotDiv<_6, _5>),
                            (Add.L( /* : Add<_6, _5, _11> */
                                (Add.L( /* : Add<_6, _4, _10> */
                                    (Add.L( /* : Add<_6, _3, _9> */
                                        (Add.L( /* : Add<_6, _2, _8> */
                                            (Add.L( /* : Add<_6, _1, _7> */
                                                (Add.Z : Add<_6, _0, _6>)
                                              ) : Add<_6, _1, _7>)
                                          ) : Add<_6, _2, _8>)
                                      ) : Add<_6, _3, _9>)
                                  ) : Add<_6, _4, _10>)
                              ) : Add<_6, _5, _11>)
                          ) : NotDiv<_6, _11>),
                        (ForAll.Cons( /* : ForAll<_7, _11> */
                            (NotDiv.Sub( /* : NotDiv<_7, _11> */
                                (NotDiv.TooBig( /* : NotDiv<_7, _4> */
                                    (LT.L( /* : LT<_4, _7> */
                                        (LT.L( /* : LT<_4, _6> */
                                            (LT.Z : LT<_4, _5>)
                                          ) : LT<_4, _6>)
                                      ) : LT<_4, _7>)
                                  ) : NotDiv<_7, _4>),
                                (Add.L( /* : Add<_7, _4, _11> */
                                    (Add.L( /* : Add<_7, _3, _10> */
                                        (Add.L( /* : Add<_7, _2, _9> */
                                            (Add.L( /* : Add<_7, _1, _8> */
                                                (Add.Z : Add<_7, _0, _7>)
                                              ) : Add<_7, _1, _8>)
                                          ) : Add<_7, _2, _9>)
                                      ) : Add<_7, _3, _10>)
                                  ) : Add<_7, _4, _11>)
                              ) : NotDiv<_7, _11>),
                            (ForAll.Cons( /* : ForAll<_8, _11> */
                                (NotDiv.Sub( /* : NotDiv<_8, _11> */
                                    (NotDiv.TooBig( /* : NotDiv<_8, _3> */
                                        (LT.L( /* : LT<_3, _8> */
                                            (LT.L( /* : LT<_3, _7> */
                                                (LT.L( /* : LT<_3, _6> */
                                                    (LT.L( /* : LT<_3, _5> */
                                                        (LT.Z : LT<_3, _4>)
                                                      ) : LT<_3, _5>)
                                                  ) : LT<_3, _6>)
                                              ) : LT<_3, _7>)
                                          ) : LT<_3, _8>)
                                      ) : NotDiv<_8, _3>),
                                    (Add.L( /* : Add<_8, _3, _11> */
                                        (Add.L( /* : Add<_8, _2, _10> */
                                            (Add.L( /* : Add<_8, _1, _9> */
                                                (Add.Z : Add<_8, _0, _8>)
                                              ) : Add<_8, _1, _9>)
                                          ) : Add<_8, _2, _10>)
                                      ) : Add<_8, _3, _11>)
                                  ) : NotDiv<_8, _11>),
                                (ForAll.Cons( /* : ForAll<_9, _11> */
                                    (NotDiv.Sub( /* : NotDiv<_9, _11> */
                                        (NotDiv.TooBig( /* : NotDiv<_9, _2> */
                                            (LT.L( /* : LT<_2, _9> */
                                                (LT.L( /* : LT<_2, _8> */
                                                    (LT.L( /* : LT<_2, _7> */
                                                        (LT.L( /* : LT<_2, _6> */
                                                            (LT.L( /* : LT<_2, _5> */
                                                                (LT.L( /* : LT<_2, _4> */
                                                                    (LT.Z : LT<_2, _3>)
                                                                  ) : LT<_2, _4>)
                                                              ) : LT<_2, _5>)
                                                          ) : LT<_2, _6>)
                                                      ) : LT<_2, _7>)
                                                  ) : LT<_2, _8>)
                                              ) : LT<_2, _9>)
                                          ) : NotDiv<_9, _2>),
                                        (Add.L( /* : Add<_9, _2, _11> */
                                            (Add.L( /* : Add<_9, _1, _10> */
                                                (Add.Z : Add<_9, _0, _9>)
                                              ) : Add<_9, _1, _10>)
                                          ) : Add<_9, _2, _11>)
                                      ) : NotDiv<_9, _11>),
                                    (ForAll.Cons( /* : ForAll<_10, _11> */
                                        (NotDiv.Sub( /* : NotDiv<_10, _11> */
                                            (NotDiv.TooBig( /* : NotDiv<_10, _1> */
                                                (LT.L( /* : LT<_1, _10> */
                                                    (LT.L( /* : LT<_1, _9> */
                                                        (LT.L( /* : LT<_1, _8> */
                                                            (LT.L( /* : LT<_1, _7> */
                                                                (LT.L( /* : LT<_1, _6> */
                                                                    (LT.L( /* : LT<_1, _5> */
                                                                        (LT.L( /* : LT<_1, _4> */
                                                                            (LT.L( /* : LT<_1, _3> */
                                                                                (LT.Z : LT<_1, _2>)
                                                                              ) : LT<_1, _3>)
                                                                          ) : LT<_1, _4>)
                                                                      ) : LT<_1, _5>)
                                                                  ) : LT<_1, _6>)
                                                              ) : LT<_1, _7>)
                                                          ) : LT<_1, _8>)
                                                      ) : LT<_1, _9>)
                                                  ) : LT<_1, _10>)
                                              ) : NotDiv<_10, _1>),
                                            (Add.L( /* : Add<_10, _1, _11> */
                                                (Add.Z : Add<_10, _0, _10>)
                                              ) : Add<_10, _1, _11>)
                                          ) : NotDiv<_10, _11>),
                                        (ForAll.Empty( /* : ForAll<_11, _11> */
                                            (LT.Z : LT<_11, _12>)
                                          ) : ForAll<_11, _11>)
                                      ) : ForAll<_10, _11>)
                                  ) : ForAll<_9, _11>)
                              ) : ForAll<_8, _11>)
                          ) : ForAll<_7, _11>)
                      ) : ForAll<_6, _11>)
                  ) : ForAll<_5, _11>)
              ) : ForAll<_4, _11>)
          ) : ForAll<_3, _11>)
      ) : ForAll<_2, _11>);
  
  public static function main(): Void {
    Sys.print('$prime11');
  }
}