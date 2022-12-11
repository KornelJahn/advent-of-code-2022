module Day08

AbstractInput = AbstractArray{<:Integer, 2}

function parse_input(raw::AbstractString)
    n = length(collect(Iterators.takewhile(!=('\n'), raw)))
    v = parse.(Int, Vector{Char}(replace(raw, "\n" => "")))
    return reshape(v, (n, n))
end

solve_part1(input::AbstractInput) = count(
    I->is_visible(input, Tuple(I)...),
    CartesianIndices(input)
)

solve_part2(input::AbstractInput) = maximum(
    scenic_score(input, Tuple(I)...) for I in CartesianIndices(input)
)

is_visible(A::AbstractInput, i::T, j::T) where {T<:Integer} = any(
    v->all(<(A[i, j]), v),
    directions(A, i, j)
)

function directions(A::AbstractInput, i::T, j::T) where {T<:Integer}
    @views return [
        A[i, (j-1):-1:1], # up
        A[i, (j+1):end], # down
        A[(i-1):-1:1, j], # left
        A[(i+1):end, j], # right
    ]
end

scenic_score(A::AbstractInput, i::T, j::T) where {T<:Integer} = prod(
    v->viewing_distance(v, A[i, j]),
    directions(A, i, j)
)

function viewing_distance(v::AbstractVector{<:Integer}, height::Integer)
    idx = findfirst(>=(height), v)
    return idx === nothing ? length(v) : idx
end

end # module
