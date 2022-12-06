module Day6

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a vector of strings.
"""
function parse_input(::Day{6}, raw::AbstractString)
    return split(strip(raw), "\n")
end

AbstractInput = AbstractVector{<:AbstractString}

function solve(::Day{6}, ::Part{1}, input::AbstractInput)
    return Tuple(find_start.(input, windowsize=4))
end

function solve(::Day{6}, ::Part{2}, input::AbstractInput)
    return Tuple(find_start.(input, windowsize=14))
end

function find_start(msg::AbstractString; windowsize::Int)
    for stop in windowsize:length(msg)
        start = stop - windowsize + 1
        if is_unique(msg[start:stop])
            return stop
        end
    end
    return nothing
end

is_unique(x) = length(Set(x)) == length(x)

end # module
