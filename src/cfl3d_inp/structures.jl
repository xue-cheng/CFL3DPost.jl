
struct CFL3DFiles
  iofiles::String
  grid::String
  p3dg::String
  p3dq::String
  out::String
  res::String
  turres::String
  blomax::String
  out15::String
  prout::String
  out20::String
  ovrlp::String
  patch::String
  restart::String
end

read(io::IO, ::Type{CFL3DFiles}) = CFL3DFiles([readline(io) for _ in 1:14]...)
show(io::IO, files::CFL3DFiles) = join(io, map(i -> getfield(files, i), 1:14), '\n')

implicit(var::AbstractString) = var[1] in "ijklmn" ? Int : Float64

struct CFL3DTitle
  keywords::Dict{String,Real}
  title::String
end

function show(io::IO, t::CFL3DTitle)
  println(io, '>')
  for (k, w) in pairs(t.keywords)
    println(io, k, ' ', w)
  end
  println(io, '<')
  print(io, t.title)
end

function read(io::IO, ::Type{CFL3DTitle})
  kw = Dict{String,Real}()
  l = readline(io)
  if startswith(l, '>')
    l = readline(io)
    while !startswith(l, '<')
      k, w = split(l)
      val = parse(implicit(k), w)
      kw[k] = val
      l = readline(io)
    end
    title = readline(io)
  else
    title = l
  end
  return CFL3DTitle(kw, title)
end


abstract type CFL3DLine end

function show(io::IO, lt::LT) where {LT<:CFL3DLine}
  nf = fieldcount(LT)
  mat = Matrix{String}(undef, nf, 2)
  w = Vector{Int}(undef, nf)
  @inbounds for i in 1:nf
    mat[i, 1] = string(fieldname(LT, i))
    mat[i, 2] = string(getfield(lt, i))
    w[i] = max(length(mat[i, 1]), length(mat[i, 2]), 9) + 1
  end
  for j in 1:2
    for i in 1:nf
      print(io, ' '^(w[i] - length(mat[i, j])), mat[i, j])
    end
    if j == 1
      println(io)
    end
  end
end

function read(io::IO, ::Type{LT}) where {LT<:CFL3DLine}
  readline(io)
  data = split(readline(io))
  @assert length(data) == fieldcount(LT)
  return LT(map(i -> parse(fieldtype(LT, i), data[i]), eachindex(data))...)
end

struct CFL3DCondition <: CFL3DLine
  xmach::Float64
  alpha::Float64
  beta::Float64
  ReUe::Float64
  Tinf::Float64
  ialph::Int
  ihstry::Int
end

struct CFL3DRefValues <: CFL3DLine
  sref::Float64
  cref::Float64
  bref::Float64
  xmc::Float64
  ymc::Float64
  zmc::Float64
end

struct CFL3DTimeControl <: CFL3DLine
  dt::Float64
  irest::Int
  iflagts::Int
  fmax::Float64
  iunst::Int
  cfl_tau::Float64
end

struct CFL3DCounters <: CFL3DLine
  ngrid::Int
  np3d::Int
  nprint::Int
  nwrest::Int
  ichk::Int
  i2d::Int
  ntstep::Int
  ita::Int
end