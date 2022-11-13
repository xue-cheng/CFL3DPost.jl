# CFL3DPost

[![Build Status](https://github.com/xue-cheng/CFL3DPost.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/xue-cheng/CFL3DPost.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://coveralls.io/repos/github/xue-cheng/CFL3DPost.jl/badge.svg?branch=master)](https://coveralls.io/github/xue-cheng/CFL3DPost.jl?branch=master)

# Install
For any Julia >= 1.6:
```
] add https://github.com/xue-cheng/CFL3DPost.jl
```
# Usage
## Split CFL3D Solution Movie
```julia
using CFL3DPost
splitter = MovieSplitter(;prefix="movie_", convert="native") 
# - prefix: prefix of output file, default: "movie_"
# - convert: for specifying the byte-order of the file data; one of
#    - "native": use the host byte order [default]
#    - "big-endian": use big-endian byte-order
#    - "little-endian": use little-endian byte-order
splitter("cfl3d.inp") # cfl3d input file
```
see also: [src/movie_splitter.jl](src/movie_splitter.jl) and [test/movie_splitter.jl](test/movie_splitter.jl)