module Day09

const AXIAL_DIR_CODES = ['U', 'R', 'D', 'L']
const AXIAL_DIRS = [(0, 1), (1, 0), (0, -1), (-1, 0)]
const DIAGONAL_DIRS = [(1, 1), (1, -1), (-1, -1), (-1, 1)]

function parse_input(raw::AbstractString)
    dirs = Dict(AXIAL_DIR_CODES .=> AXIAL_DIRS)
    lines = split(strip(raw), '\n')
    function convert_line_to_iterator(line)
        (rawdir, rawcnt) = split(line)
        return Iterators.repeated(dirs[rawdir[1]], parse(Int, rawcnt))
    end
    return Iterators.flatten(convert_line_to_iterator.(lines))
end

solve_part1(input) = visited_tail_position_count(input)

solve_part2(input) = visited_tail_position_count(input, taillen=9)

function visited_tail_position_count(directions; taillen::Int = 1)
    head_history = head_positions(directions)
    tail_histories = accumulate(
        (hist, _)->tail_positions(hist),
        1:taillen,
        init=head_history
    )
    return length(unique(tail_histories[end]))
end

# Assume eltype of iterables is the same
cat(iterables...) = Iterators.flatten(iterables)

function head_positions(directions)
    initial = (0, 0)
    return collect(cat((initial,), accumulate(.+, directions, init=initial)))
end

function tail_positions(heads)
    initial = (0, 0)
    return collect(cat((initial,), accumulate(next_tail, heads, init=initial)))
end

AbstractVec = Tuple{T, T} where {T<:Integer}

function next_tail(tail::T, head::T) where {T<:AbstractVec}
    d = distance_squared(head, tail)
    @assert d <= 8
    if d <= 2
        return tail
    elseif d == 4
        # Axial head movement
        return minimum_distance_tail(tail, head, AXIAL_DIRS...)
    elseif d >= 5
        # Diagonal head movement
        return minimum_distance_tail(tail, head, DIAGONAL_DIRS...)
    end
end

function minimum_distance_tail(
    tail::T,
    head::T,
    dirs::T...
) where {T<:AbstractVec}
    tail_options = [tail .+ dir for dir in dirs]
    return tail_options[argmin(distance_squared.(tail_options, Ref(head)))]
end

distance_squared(p::T, q::T) where {T<:AbstractVec} = sum((p .- q).^2)

end # module
