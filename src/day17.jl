module Day17

function parse_input(raw::AbstractString)
    return strip(raw)
end

Input = AbstractString

const SHAPES = permutedims.(map(a->Bool.(a), [
    [1 1 1 1],
    [0 1 0;
     1 1 1;
     0 1 0],
    [1 1 1;
     0 0 1;
     0 0 1],
    [1;
     1;
     1;
     1],
    [1 1;
     1 1]
]))

function solve_part1(winddirs::Input)
    return extrapolate(winddirs, round_count=2022)
end

function solve_part2(winddirs::Input)
    return extrapolate(winddirs, round_count=1000000000000)
end

AbstractChamber = AbstractArray{Bool, 2}
AbstractShape = AbstractArray{Bool, 2}

function extrapolate(winddirs::Input; round_count::Integer)
    test_length = 2*length(winddirs)
    if round_count <= test_length
        return sum(play_rounds(winddirs, round_count))
    end
    height_increments = play_rounds(winddirs, test_length)
    aperiodic_head_length, period = periodicity_parameters(height_increments)
    if round_count <= aperiodic_head_length
        return sum(height_increments[1:round_count])
    end
    aperiodic_part = @view height_increments[1:aperiodic_head_length]
    aperiodic_height = sum(aperiodic_part)
    periodic_start = aperiodic_head_length + 1
    periodic_range = periodic_start:(periodic_start + period - 1)
    periodic_part = @view height_increments[periodic_range]
    period_height = sum(periodic_part)
    (q, r) = divrem(round_count - aperiodic_head_length, period)
    @views return aperiodic_height + q*period_height + sum(periodic_part[1:r])
end

function play_rounds(winddirs::Input, round_count::Integer)
    chamber = falses(7, 4*round_count)
    iter_winddir = Iterators.cycle(winddirs)
    winddir_state = 1
    iter_shapes = Iterators.cycle(SHAPES)
    top = 0
    height_increments = Vector{Int}(undef, round_count)
    for (k, shape) in zip(1:round_count, iter_shapes)
        (i, j, winddir_state) = move(
            chamber,
            top,
            shape,
            iter_winddir,
            winddir_state
        )
        new_top = update_chamber!(chamber, shape, i, j)
        height_increments[k] = new_top - top
        # top = collapse_chamber!(chamber, new_top)
        top = new_top
    end
    return height_increments
end

function move(
    chamber::AbstractChamber,
    top::Integer,
    shape::AbstractShape,
    iter_winddir,
    winddir_state::Integer,
)
    i = 3
    j = top + 4
    while true
        (winddir, winddir_state) = iterate(iter_winddir, winddir_state)
        delta_i = winddir == '<' ? -1 : 1
        if can_move_to(chamber, shape, i+delta_i, j)
            i += delta_i
        end
        if can_move_to(chamber, shape, i, j-1)
            j -= 1
        else
            break
        end
    end
    return i, j, winddir_state
end

function can_move_to(
    chamber::AbstractChamber,
    shape::AbstractShape,
    i::Integer,
    j::Integer,
)
    (a, b) = size(shape) .- 1
    ranges = i:(i+a), j:(j+b)
    if !checkbounds(Bool, chamber, ranges...)
       return false
    end
    chamber_window = @view chamber[ranges...]
    # Eliminate allocations
    # return !any(shape .& chamber_window)
    return sum(shape[i] & chamber_window[i] for i in 1:length(shape)) == 0
end

function update_chamber!(
    chamber::AbstractChamber,
    shape::AbstractShape,
    i::Integer,
    j::Integer,
)
    (a, b) = size(shape) .- 1
    @views chamber[i:(i+a), j:(j+b)] .|= shape
    # Eliminate allocations
    # return sum(reduce(|, chamber, dims=1))
    total = 0
    for l in 1:size(chamber, 2)
        is_occupied = false
        for k in 1:size(chamber, 1)
            is_occupied |= chamber[k, l]
        end
        total += is_occupied
    end
    return total
end

# function collapse_chamber!(
#     chamber::AbstractChamber,
#     top::Integer
# )
#     full_rows = reduce(&, chamber[:, 1:top], dims=1)
#     indices = findall(full_rows)
#     if isempty(indices)
#         return top
#     end
#     lin = LinearIndices(full_rows)
#     idx = lin[indices[end]]
#     println("collapse @ $idx")
#     new_top = top - idx
#     chamber[:, 1:new_top] .= chamber[:, (idx+1):top]
#     chamber[:, (new_top+1):end] .= false
#     return new_top
# end

function periodicity_parameters(x)
    @views periods = [seqperiod(x[k:end]) for k in 1:div(length(x), 2)]
    period = periods[end]
    aperiodic_head_length = sum(
        1 for _ in Iterators.takewhile(!=(period), periods)
    )
    @assert all(==(period), periods[(aperiodic_head_length+1):end])
    return aperiodic_head_length, period
end

function seqperiod(x)
    # Adapted from:
    # https://discourse.julialang.org/t/julia-implementation-of-seqperiod-from-matlab/66791/9
    for k in 2:length(x)
        if x[k] == x[1]
            if all(j -> x[j] == x[j-k+1], k:lastindex(x))
                return k - 1
            end
        end
    end
    return length(x)
end

end # module
