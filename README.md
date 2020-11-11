# nimler

Nimler is a library for authoring Erlang and Elixir NIFs in the Nim programming language. It has mostly complete bindings for the Erlang NIF API and some accessories for making writing NIFs easier, including idiomatic functions for converting between Erlang terms and Nim types, and simplifications for using resource objects.

Mostly, Nimler is a minimal, zero-dependency wrapper for Erlang NIF API.

## Build status

| Target               | Status                                                                 |
|----------------------|------------------------------------------------------------------------|
| x86_64-linux | ![](https://github.com/wltsmrz/nimler/workflows/build-x64/badge.svg)   |
| arm64-linux  | ![](https://github.com/wltsmrz/nimler/workflows/build-arm64/badge.svg) |


```bash
$ nimble install nimler
```

## Documentation

Nimler is documented at [smrz.dev/nimler](https://smrz.dev/nimler).

## Sample

```nim
import nimler

func add(env: ptr ErlNifEnv, a: int, b: int): (ErlAtom, int) {.xnif.} =
  (AtomOk, a + b)
  
func sub(env: ptr ErlNifEnv, a: int, b: int): (ErlAtom, int) {.xnif.} =
  (AtomOk, a - b)

exportNifs "Elixir.NifMath", [ add, sub ]
```

