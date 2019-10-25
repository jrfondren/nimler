import ../../nimler

proc codec_int32(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let a1 = argv[0].decode(env, int32).get(0)
  let a2 = argv[1].decode(env, int32).get(0)
  let r = a1 + a2
  discard 1'i32.encode(env)
  return r.encode(env)

proc codec_uint32(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let a1 = argv[0].decode(env, uint32).get(0)
  let a2 = argv[1].decode(env, uint32).get(0)
  let r = a1 + a2
  discard 1'u32.encode(env)
  return r.encode(env)

proc codec_double(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let v = argv[0].decode(env, float64).get()
  discard 1.0'f64.encode(env)
  return v.encode(env)

proc codec_uint64(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let v = argv[0].decode(env, uint64).get()
  discard 1'u64.encode(env)
  return v.encode(env)

proc codec_atom(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let a1 = argv[0].decode(env, ErlAtom).get(ErlAtom((val: "default")))
  doAssert(a1.val == "test")
  let v = ErlAtom((val: "test"))
  doAssert(a1 == v)
  let vv = (val: "test")
  doAssert(a1 == vv)
  return a1.encode(env)

proc codec_string(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let a1 = argv[0].decode(env, ErlString).get()
  let a2 = argv[1].decode(env, ErlString).get(ErlString("default"))
  doAssert(a1 == "test")
  doAssert(a2 == "default")
  let a3 = "test".encode(env)
  doAssert(a3.decode(env, string).get() == "test")
  return a1.encode(env)

proc codec_binary(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  let a1 = argv[0].decode(env, ErlBinary)
  if a1.isNone():
    return enif_make_badarg(env)
  let a1v = a1.get()
  doAssert(a1v.size == 5)
  doAssert(cast[ptr UncheckedArray[char]](a1v.data) == "test".cstring)
  return a1v.encode(env)

proc codec_varargs_tuple(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  return encode(
    enif_make_int(env, cint(1)),
    enif_make_int(env, cint(2)),
    enif_make_int(env, cint(3)),
    env)

proc codec_array_tuple(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  return encode([
    enif_make_int(env, cint(1)),
    enif_make_int(env, cint(2)),
    enif_make_int(env, cint(3))
  ], env)

proc codec_list(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
   return encode(@[
     enif_make_int(env, cint(1)),
     enif_make_int(env, cint(2)),
     enif_make_int(env, cint(3))
   ], env)

proc codec_result_ok(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  return ResultOk(argv[0]).encode(env)

proc codec_result_error(env: ptr ErlNifEnv, argc: cint, argv: ErlNifArgs): ErlNifTerm =
  return ResultErr(argv[0]).encode(env)

export_nifs("Elixir.NimlerWrapper", @[
  ("codec_int32", 2, codec_int32),
  ("codec_uint32", 2, codec_uint32),
  ("codec_atom", 1, codec_atom),
  ("codec_string", 1, codec_string),
  ("codec_binary", 1, codec_binary),
  ("codec_varargs_tuple", 0, codec_varargs_tuple),
  ("codec_array_tuple", 0, codec_array_tuple),
  ("codec_list", 0, codec_list),
  ("codec_result_ok", 1, codec_result_ok),
  ("codec_result_error", 1, codec_result_error),
  ("codec_double", 1, codec_double),
  ("codec_uint64", 1, codec_uint64)
])

