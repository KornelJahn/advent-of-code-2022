module Day08

function parse_input(raw::AbstractString)
    n = length(collect(Iterators.takewhile(!=('\n'), raw)))
    v = parse.(Int, Vector{Char}(replace(raw, "\n" => "")))
    return reshape(v, (n, n))
end

Input = AbstractArray{<:Integer, 2}

solve_part1(grid::Input) = count(
    I->is_visible(grid, Tuple(I)...),
    CartesianIndices(grid)
)

solve_part2(grid::Input) = maximum(
    scenic_score(grid, Tuple(I)...) for I in CartesianIndices(grid)
)

is_visible(grid::Input, i::T, j::T) where {T<:Integer} = any(
    v->all(<(grid[i, j]), v),
    directions(grid, i, j)
)

function directions(grid::Input, i::T, j::T) where {T<:Integer}
    @views return [
        grid[i, (j-1):-1:1], # up
        grid[i, (j+1):end], # down
        grid[(i-1):-1:1, j], # left
        grid[(i+1):end, j], # right
    ]
end

scenic_score(grid::Input, i::T, j::T) where {T<:Integer} = prod(
    v->viewing_distance(v, grid[i, j]),
    directions(grid, i, j)
)

function viewing_distance(heights::AbstractVector{<:Integer}, height::Integer)
    idx = findfirst(>=(height), heights)
    return idx === nothing ? length(heights) : idx
end

end # module
