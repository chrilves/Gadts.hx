# [Generalized Algebraic Data Types](https://en.wikipedia.org/wiki/Generalized_algebraic_data_type) example in [Haxe](https://haxe.org/)

- [On Pijul Nest](https://nest.pijul.com/chrilves/Gadts.hx)
- [On GitLab](https://gitlab.com/chrilves/Gadts.hx)
- [On GitGub](https://github.com/chrilves/Gadts.hx)

[Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type) (called **ADTs**) are a marvelous tool to model data stuctures. They are intensively used in typed functional programming like in [Haskell](https://haskell-lang.org/), [OCaml](https://ocaml.org), [Scala](https://www.scala-lang.org/), [F#](https://fsharp.org/) but also in modern imperative programming languages like [Rust](https://www.rust-lang.org), [Haxe](https://haxe.org/) or [TypeScript](https://www.typescriptlang.org/docs/handbook/advanced-types.html).


**ADTs** are defined like this: a **type** `T`, eventually with **type variables** (a.k.a. **generics**) and a finite set of functions called **constructor** or **variant**, whose return type is `T`:

```java
f1: C1 -> T
...
fn: Cn -> T
```

For example, the type of lists whose elements are of type `a`, called `List<a>`, is defined like this:

```haxe
enum List<A> {
  Nil<A>: List<A>;
  Cons<A>(head: A, tail: List<A>): List<A>;
}
```

Note that, *for any type `A`*, all *constructors* are required to produce values of type `List<A>`. [Generalized Algebraic Data Types](https://en.wikipedia.org/wiki/Generalized_algebraic_data_type) (called **GADTs**) remove this restriction, allowing *constructors* to produce values for specific types `A`. For example:

```haxe
enum T<A> {
  IsInt: T<Int>;
}
```

The *constructor* `IsInt` only produces a value of type `T<Int>` thus only in the case `A = Int`. We can then encode properties over types. For example having a value of type `T<A>` is only possible if `A` is `Int` but nothing else.

```haxe
function f<A>(a: A, evidence: T<A>): Int {
  return switch (evidence) {
    case IsInt: a;
  }
}
```

This project encodes the property that the type `N` represents a prime number. The natural number number `N` is encoded as the type `List<List<...List<String>>>` with exactly `N` occurrences of `List`. The property is:
> The natural number `N` is prime *if and only if* there exists a value of type `prime<_N>`.

For any prime number `N` the program computes a **valid value** of type `prime<_N>`

# Usage

This project is written in [Haxe](https://haxe.org/). It can be compiled to [Python](https://www.python.org), [Lua](https://www.lua.org), [NodeJS](https://nodejs.org), [Java](https://www.java.com), [C#](https://www.mono-project.com), *C++* and maybe more.

Once compiled, run the program, where `N` is a prime natural number, via:

```sh
Gadts N
```

It produces a file named `PrimeN.hx` containing the type declarations and the value of type `Prime<_N>`. This is a valid *Haxe* file that can be compiled and run to print the value.

Open the file `PrimeN.hx` to see the value `primeN` of type `Prime<_N>`.

## Lua

```sh
haxe python_lua.hxml
lua build/Gadts.lua 11
```

## Python

```sh
haxe python_lua.hxml
python build/Gadts.py 11
```

## Java

```sh
haxe java.hxml
java -jar build/Gadts.java/Gadts.jar 11
```

## NodeJS

```sh
haxe node.hxml
node build/Gadts.js 11
```


# Encoding

## Natural numbers

```haxe
typedef S<N> = List<N>;

typedef _0 = String;
typedef _1 = S<_0>; // List<String>
typedef _2 = S<_1>; // List<List<String>>
typedef _3 = S<_2>; // List<List<List<String>>>
typedef _4 = S<_3>;
typedef _5 = S<_4>;
typedef _6 = S<_5>;
typedef _7 = S<_6>;
typedef _8 = S<_7>;
typedef _9 = S<_8>;
typedef _10 = S<_9>;
typedef _11 = S<_10>;
typedef _12 = S<_11>;
```

## `N1 < N2`

```haxe
enum LT<N1, N2> {
  /* N < (N+1) */
  Z<N> : LT<N, S<N>>;

  /* N1 < N2 => N1 < (N2+1) */
  L<N1,N2>(hr: LT<N1,N2>) :  LT<N1, S<N2>>; 
}
```

## `N1 + N2 = N3`

```haxe
enum Add<N1, N2, N3> {
  /* N + 0 = N */
  Z<N>() : Add<N, _0, N>;

  /* N1 + N2 = N3 => N1 + (N2+1) = (N3+1) */
  L<N1,N2,N3>(hr: Add<N1, N2, N3>) : Add<N1, S<N2>, S<N3>>; 
}
```

## `N1 ∤ N2`

`N1` does not divide `N2`

```haxe
enum NotDiv<N1, N2> {
  /* (N2+1) < N1 => N1 ∤ (N2+1) */
  TooBig<N1, N2>(lt: LT<S<N2>, N1>): NotDiv<N1, S<N2>>;

  /* N1 ∤ N2 => N1 ∤ (N1+N2) */
  Sub<N1, N2, N3>(hr: NotDiv<N1, N2>, add: Add<N1, N2, N3>): NotDiv<N1, N3>; 
}
```

## `∀N, N1 ≤ N < N2 ⇒ N ∤ N2`

```haxe
enum ForAll<N1, N2> {
  /* N2 < (N1+1) ⇒ ForAll<N1, N2> */
  Empty<N1, N2>(lt: LT<N2, S<N1>>) : ForAll<N1, N2>;

  /* N1 ∤ N2 && ForAll<(N1+1), N2> => ForAll<N1, N2> */
  Cons<N1, N2>(head: NotDiv<N1, N2>, tail: ForAll<S<N1>, N2>) : ForAll<N1, N2>; 
}
```

## `N` is prime

```haxe
/* N is prime if and only if ForAll<2, N> */
typedef Prime<N> = ForAll<_2, N>;
```