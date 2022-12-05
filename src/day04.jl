module Day4

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a 2D array, each 4-length row (a, b, c, d) defining two ranges (a, b)
and (c, d).
"""
function parse_input(::Day{4}, raw::AbstractString)
    regex = r"^(\d+)-(\d+),(\d+)-(\d+)$"
    lines = split(strip(raw), "\n")
    input = Array{Int}(undef, length(lines), 4)
    for (i, line) in enumerate(lines)
        input[i, :] = parse.(Ref(Int), match(regex, line).captures)
    end
    return input
end

AbstractInput = AbstractArray{<:Integer, 2}

function solve(::Day{4}, ::Part{1}, input::AbstractInput)
    # TODO: revise iteration order for more efficient vectorization
    return sum(are_completely_overlapping(row...) for row in eachrow(input))
end

function solve(::Day{4}, ::Part{2}, input::AbstractInput)
    # TODO: revise iteration order for more efficient vectorization
    return sum(are_overlapping(row...) for row in eachrow(input))
end

function are_completely_overlapping(a, b, c, d)
    return (max(a, c), min(b, d)) in [(a, b), (c, d)]
end

function are_overlapping(a, b, c, d)
    return max(a, c) <= min(b, d)
end

end # module
