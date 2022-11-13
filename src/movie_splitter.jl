@with_kw struct MovieSplitter
  marker_size::Int = 4
  prefix::String = "movie_"
  convert::String = "native"
end



function split_file(io::IO, fsize::Int, dir::AbstractString, prefix::AbstractString, ext::AbstractString; verbose::Bool=false)
  seekend(io)
  totsize = position(io)
  nframe = floor(Int, totsize / fsize)
  verbose && @info "Frame: $fsize bytes / Total: $totsize bytes [$nframe Frames]"
  width = length(digits(nframe))
  formatter = generate_formatter(joinpath(dir, "$prefix%0$(width)d.$ext"))
  seekstart(io)
  data = Vector{UInt8}(undef, fsize)
  for i in 1:nframe
    read!(io, data)
    fname = formatter(i)
    verbose && @info "+++ $fname"
    open(io -> write(io, data), fname, "w")
  end
  nlast = position(io)
  if nlast != totsize
    @warn "$(totsize-nlast) byte not read! File may be corrupted!"
  end
end

function frame_size(s::MovieSplitter, io::IO, sol::Bool)
  marker = if s.marker_size == 4
    RECMRK4B
  elseif s.marker_size == 8
    RECMRK8B
  end
  f = FortranFile(io; convert=s.convert, marker=marker)
  nblk = read(f, Int32)
  read(f)
  nrec = (sol ? 2 : 1) * nblk
  for _ in 1:nrec
    read(f)
  end
  return position(io)
end

(s::MovieSplitter)(inp::AbstractString; verbose::Bool=false) = s(CFL3DInput(inp); verbose=verbose)
function (s::MovieSplitter)(cfl3d::CFL3DInput; verbose::Bool=false)
  @assert cfl3d.timectl.dt > 0 "not an unsteady case"
  splitg = cfl3d.timectl.iunst > 0
  splitq = true # always split q file
  gfile = joinpath(cfl3d.dir, cfl3d.files.p3dg)
  qfile = joinpath(cfl3d.dir, cfl3d.files.p3dq)
  if splitg
    io = open(gfile)
    gsize = frame_size(s, io, false)
    verbose && @info "Spliting grid file: $gfile -> $(s.prefix)*.g"
    split_file(io, gsize, cfl3d.dir, s.prefix, "g"; verbose=verbose)
    close(io)
  else
    cp(gfile, "$(s.prefix)static.g")
  end
  if splitq
    io = open(qfile)
    qsize = frame_size(s, io, true)
    verbose && @info "Spliting solution file: $qfile -> $(s.prefix)*.q"
    split_file(io, qsize, cfl3d.dir, s.prefix, "q"; verbose=verbose)
    close(io)
  end
end