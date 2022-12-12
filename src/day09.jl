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
    return collect(Iterators.flatten(convert_line_to_iterator.(lines)))
end

solve_part1(directions) = visited_tail_position_count(directions, knot_count=1)

solve_part2(directions) = visited_tail_position_count(directions, knot_count=9)

function visited_tail_position_count(directions; knot_count::Int)
    head_history = head_positions(directions)
    knot_histories = accumulate(
        (hist, _)->knot_positions(hist),
        1:knot_count,
        init=head_history
    )
    return length(unique(knot_histories[end]))
end

# Assume eltype of iterables is the same
cat(iterables...) = Iterators.flatten(iterables)

function head_positions(directions)
    initial = (0, 0)
    return collect(cat((initial,), accumulate(.+, directions, init=initial)))
end

function knot_positions(heads)
    initial = (0, 0)
    return collect(cat((initial,), accumulate(next_knot, heads, init=initial)))
end

AbstractVec = Tuple{T, T} where {T<:Integer}

function next_knot(curr::T, prev::T) where {T<:AbstractVec}
    # FIXME: make more efficient, relying on the direction vector between the
    # previous and the current knot, rather than their distance (direct
    # computation vs. minimum search)
    d = distance_squared(prev, curr)
    @assert d <= 8
    if d <= 2
        return curr
    elseif d == 4
        # Axial movement of the previous knot
        return minimum_distance_knot(curr, prev, AXIAL_DIRS...)
    elseif d >= 5
        # Diagonal movement of the previous knot
        return minimum_distance_knot(curr, prev, DIAGONAL_DIRS...)
    end
end

function minimum_distance_knot(
    curr::T,
    prev::T,
    dirs::T...
) where {T<:AbstractVec}
    options = [curr .+ dir for dir in dirs]
    return options[argmin(distance_squared.(options, Ref(prev)))]
end

distance_squared(p::T, q::T) where {T<:AbstractVec} = sum((p .- q).^2)

end # module
