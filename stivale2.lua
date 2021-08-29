local nldecl = require 'nldecl'

nldecl.include_names = {
  '^stivale2',
  '^STIVALE2'
}

nldecl.include_macros = {
  uint64 = {
    '^STIVALE2'
  }
}

nldecl.prepend_code = [=[
##[[
cinclude 'stivale2.h'
]]
]=]
