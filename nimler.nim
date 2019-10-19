import ./bindings/erl_nif
import ./codec

export erl_nif
export codec

template export_nifs*(module_name: string, funcs_seq: openArray[NifSpec]) =
  proc NimMain() {.gensym, importc: "NimMain".}

  var entry {.gensym.}: ErlNifEntry
  var funcs: array[len(funcs_seq), ErlNifFunc]

  for i, (name, arity, fptr) in pairs(funcs_seq):
    funcs[i] = ErlNifFunc(name: cstring(name), arity: cuint(arity), fptr: fptr)

  proc nif_init*(): ptr ErlNifEntry {.dynlib, exportc.} =
    NimMain()
    entry.major = cint(2)
    entry.minor = cint(15)
    entry.name = cstring(module_name)
    entry.num_of_funcs = funcs.len.cint
    entry.funcs = cast[ptr UncheckedArray[ErlNifFunc]](unsafeAddr(funcs[0]))
    entry.load = nil
    entry.reload = nil
    entry.upgrade = nil
    entry.unload = nil
    entry.vm_variant = cstring("beam.vanilla")
    result = addr(entry)

