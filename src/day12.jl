module Day12

using DataStructures

function parse_input(raw::AbstractString)
    stripped = strip(raw)
    rowlength = findfirst('\n', stripped) - 1
    contiguous = filter(!=('\n'), stripped)
    rowcount = div(length(contiguous), rowlength)
    startidx = findfirst('S', contiguous)
    stopidx = findfirst('E', contiguous)
    # Note the default column-major ordering
    heightmap = reshape(collect(contiguous), rowlength, rowcount)
    heightmap[startidx] = 'a'
    heightmap[stopidx] = 'z'
    return heightmap, startidx, stopidx
end

AbstractMap = AbstractArray{<:AbstractChar, 2}

Input = Tuple{<:AbstractMap, T, T} where {T<:Integer}

abstract type DirectionTrait end
struct Up <: DirectionTrait end
struct Down <: DirectionTrait end

solve_part1(input::Input) = shortest_path_length(Up(), input...)

function solve_part2(input::Input)
    (heightmap, _, stopidx) = input
    # Start a single downward search from E that yields shortest path lengths
    # to all reachable positions
    path_lengths = shortest_path_lengths(Down(), heightmap, stopidx)
    pred(height, path_length) = height == 'a' && path_length > 0
    return minimum(
        path_length for (height, path_length) in zip(heightmap, path_lengths)
        if pred(height, path_length)
    )
end

# Concept: Breadth-First Search on an unweighted graph
# https://cp-algorithms.com/graph/breadth-first-search.html#description-of-the-algorithm

function shortest_path_length(
    direction::DirectionTrait,
    heightmap::AbstractMap,
    startidx::T,
    stopidx::T,
) where {T<:Integer}
    if startidx == stopidx
        return 0
    end
    return shortest_path_lengths(direction, heightmap, startidx)[stopidx]
end

function shortest_path_lengths(
    direction::DirectionTrait,
    heightmap::AbstractMap,
    startidx::Integer,
)
    d = bfs(i->neighbors(direction, heightmap, i), startidx, length(heightmap))
    return d
end

function neighbors(
    direction::DirectionTrait,
    heightmap::AbstractMap,
    idx::Integer
)
    neighbor_indices = filter(
        i->(1 <= i <= length(heightmap)),
        (
            idx - 1, # left
            idx + 1, # right
            idx - size(heightmap, 1), # up
            idx + size(heightmap, 1), # down
        )
    )

    pred(::Up, nidx) = (Int(heightmap[nidx]) - Int(heightmap[idx])) <= 1
    pred(::Down, nidx) = (Int(heightmap[nidx]) - Int(heightmap[idx])) >= -1

    return filter(i->pred(direction, i), neighbor_indices)
end

function bfs(neighbors::Function, s::T, n::T) where {T<:Integer}
    # Alternatively a plain Vector could be used instead of a Queue
    q = Queue{Int}() # Vector{Int}()
    used = falses(n)
    d = zeros(Int, n)
    # Uncomment lines on `p` to support path reconstruction
    # p = zeros(Int, n)

    enqueue!(q, s) # push!(q, s)
    used[s] = true
    while !isempty(q)
        v = dequeue!(q) # popfirst!(q)
        for u in neighbors(v)
            if !used[u]
                used[u] = true
                enqueue!(q, u) # push!(q, u)
                d[u] = d[v] + 1;
                # p[u] = v;
            end
        end
    end
    return d
end

end # module
