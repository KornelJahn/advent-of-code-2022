module Day8

export parse_input, solve

using .Iterators: takewhile
using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

AbstractInput = AbstractArray{<:Integer, 2}

function parse_input(::Day{8}, raw::AbstractString)
    n = length(collect(takewhile(!=('\n'), raw)))
    v = parse.(Int, Vector{Char}(replace(raw, "\n" => "")))
    return reshape(v, (n, n))
end

function solve(::Day{8}, ::Part{1}, input::AbstractInput)
    return count(I->is_visible(input, Tuple(I)...), CartesianIndices(input))
end

function solve(::Day{8}, ::Part{2}, input::AbstractInput)
    return maximum(
        scenic_score(input, Tuple(I)...) for I in CartesianIndices(input)
    )
end

function is_visible(A::AbstractInput, i::Integer, j::Integer)
    return any(v->all(<(A[i, j]), v), directions(A, i, j))
end

function directions(A::AbstractInput, i::Integer, j::Integer)
    @views return [
        A[i, (j-1):-1:1], # up
        A[i, (j+1):end], # down
        A[(i-1):-1:1, j], # left
        A[(i+1):end, j], # right
    ]
end

function scenic_score(A::AbstractInput, i::Integer, j::Integer)
    return prod(v->viewing_distance(v, A[i, j]), directions(A, i, j))
end

function viewing_distance(v::AbstractVector{<:Integer}, height::Integer)
    idx = findfirst(>=(height), v)
    return idx === nothing ? length(v) : idx
end

end # module
