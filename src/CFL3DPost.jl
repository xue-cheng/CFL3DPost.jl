module CFL3DPost

import Base: read, show
using Formatting
using FortranFiles
using Parameters


include("cfl3d_inp/cfl3d_inp.jl")
include("movie_splitter.jl")

export CFL3DInput
export MovieSplitter

end
