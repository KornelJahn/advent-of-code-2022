module Day1

export parse_input, solve

using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

"""
Return a vector containing vectors of numbers.
"""
function parse_input(::Day{1}, raw::AbstractString)
    groups = split(strip(raw), "\n\n")
    convert(group) = parse.(Ref(Int), split(strip(group), "\n"))
    return convert.(groups)
end

AbstractInput = AbstractVector{<:AbstractVector{<:Integer}}

solve(::Day{1}, ::Part{1}, input::AbstractInput) = maximum(sum.(input))

function solve(::Day{1}, ::Part{2}, input::AbstractInput)
    return sum(sort(sum.(input), rev=true)[1:3])
end

end # module
