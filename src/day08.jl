module Day8

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a 2D array of integers.
"""
function parse_input(::Day{8}, raw::AbstractString)
    n = length(collect(Iterators.takewhile(!=('\n'), raw)))
    v = parse.(Int, Vector{Char}(replace(raw, "\n" => "")))
    return reshape(v, (n, n))
end

AbstractInput = AbstractArray{<:Integer, 2}

function solve(::Day{8}, ::Part{1}, input::AbstractInput)
    inner_count = count(
        indices->is_visible(input, indices...),
        Iterators.product(2:(size(input, 1) - 1), 2:(size(input, 2) - 1))
    )
    sides_count = 2 * (sum(size(input)) - 2)
    return sides_count + inner_count
end

function solve(::Day{8}, ::Part{2}, input::AbstractInput)
    return maximum(
        scenic_score(input, i, j) for (i, j) in
        Iterators.product(2:(size(input, 1) - 1), 2:(size(input, 2) - 1))
    )
end

function is_visible(A::AbstractInput, i::Integer, j::Integer)
    return any(v->all(<(A[i, j]), v), directions(A, i, j))
end

function directions(A::AbstractInput, i::Integer, j::Integer)
    @views return [
        A[i, (j-1):-1:1],
        A[i, (j+1):end],
        A[(i-1):-1:1, j],
        A[(i+1):end, j],
    ]
end

function scenic_score(A::AbstractInput, i::Integer, j::Integer)
    height = A[i, j]
    return prod(v->viewing_distance(v, height), directions(A, i, j))
end

function viewing_distance(v::AbstractVector{<:Integer}, height::Integer)
    idx = findfirst(>=(height), v)
    return idx === nothing ? length(v) : idx
end

end # module
