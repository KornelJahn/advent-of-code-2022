module Puzzle

export DayTrait, Day, PartTrait, Part, parse_input, solve

abstract type DayTrait end
struct Day{N} <: DayTrait end

abstract type PartTrait end
struct Part{N} <: PartTrait end

parse_input(::DayTrait, raw::AbstractString) = nothing
solve(::DayTrait, ::PartTrait, input) = nothing

end # module
