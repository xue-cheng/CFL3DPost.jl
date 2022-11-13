@testset "movie_splitter" begin
  case = "pitch0012"
  dir = ".movie1"
  mkpath(joinpath(case, dir))
  splitter = MovieSplitter(prefix=joinpath(dir, "movie_"))
  inp = CFL3DInput(joinpath(case, "n0012_pitch.inp"))
  splitter(inp; verbose=true)
  
  inpfile = joinpath(case, "n0012_pitch2.inp")
  dir = ".movie2"
  mkpath(joinpath(case, dir))
  splitter = MovieSplitter(prefix=joinpath(dir, "movie_"))
  splitter(inpfile; verbose=false)
end