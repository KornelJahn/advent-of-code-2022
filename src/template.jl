module DayDAY

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

AbstractInput = Any

function parse_input(::Day{DAY}, raw::AbstractString)
    input = nothing
    return input
end

function solve(::Day{DAY}, ::Part{1}, input::AbstractInput)
    return nothing
end

function solve(::Day{DAY}, ::Part{2}, input::AbstractInput)
    return nothing
end

end # module
