module Day1

export parse_input, solve

using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

AbstractInput = AbstractVector{<:AbstractVector{<:Integer}}

function parse_input(::Day{1}, raw::AbstractString)
    groups = split(strip(raw), "\n\n")
    convert(group) = parse.(Ref(Int), split(strip(group), "\n"))
    return convert.(groups)
end

solve(::Day{1}, ::Part{1}, input::AbstractInput) = maximum(sum.(input))

solve(::Day{1}, ::Part{2}, input::AbstractInput) = sum(
    sort(sum.(input), rev=true)[1:3]
)

end # module
