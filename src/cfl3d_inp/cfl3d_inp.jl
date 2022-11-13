include("structures.jl")

struct CFL3DInput
  dir::String
  inp::String
  files::CFL3DFiles
  title::CFL3DTitle
  condition::CFL3DCondition
  refval::CFL3DRefValues
  timectl::CFL3DTimeControl
  counters::CFL3DCounters
end

function CFL3DInput(file::AbstractString; verbose::Bool=false)
  isfile(file) || error("File Not Exists: $file")
  dir, inp = splitdir(abspath(file))
  open(file) do io
    files = read(io, CFL3DFiles)
    verbose && @info "$files"
    title = read(io, CFL3DTitle)
    verbose && @info "Keywords & Title:\n$title"
    cond = read(io, CFL3DCondition)
    verbose && @info "Conditions:\n$cond"
    refv = read(io, CFL3DRefValues)
    verbose && @info "References:\n$refv"
    timectl = read(io, CFL3DTimeControl)
    verbose && @info "Time Control:\n$timectl"
    counters = read(io, CFL3DCounters)
    verbose && @info "Counters:\n$counters"
    return CFL3DInput(
      dir,
      inp,
      files,
      title,
      cond,
      refv,
      timectl,
      counters)
  end
end
