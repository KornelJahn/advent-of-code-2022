module Day12

using DataStructures

AbstractMap = AbstractArray{<:AbstractChar, 2}
AbstractInput = Tuple{<:AbstractMap, T, T} where {T<:Integer}

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

function solve_part1(input::AbstractInput)
    return shortest_path_length(input...)
end

function solve_part2(input::AbstractInput)
    (heightmap, _, stopidx) = input
    start_indices = findall(==('a'), heightmap[:])
    return (
        shortest_path_length.(Ref(heightmap), start_indices, Ref(stopidx))
        |> i->filter(>(0), i)
        |> minimum
    )
end

# Concept: Breadth-First Search on an unweighted graph
# https://cp-algorithms.com/graph/breadth-first-search.html#description-of-the-algorithm

function shortest_path_length(
    heightmap::AbstractMap,
    startidx::T,
    stopidx::T
) where {T<:Integer}
    if startidx == stopidx
        return 0
    end
    d = bfs(i->neighbors(heightmap, i), startidx, length(heightmap))
    return d[stopidx]
end

function neighbors(heightmap::AbstractMap, idx::Integer)
    neighbor_indices = filter(
        i->(1 <= i <= length(heightmap)),
        (
            idx - 1, # left
            idx + 1, # right
            idx - size(heightmap, 1), # up
            idx + size(heightmap, 1), # down
        )
    )
    pred(nidx) = (Int(heightmap[nidx]) - Int(heightmap[idx])) <= 1
    return filter(pred, neighbor_indices)
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
