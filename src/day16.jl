module Day16

using DataStructures

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    valve_count = length(lines)
    # Order valves by decreasing flow rate except the AA valve that must come
    # first for simplicity. This way, relevant valves have small indices,
    # ensuring their state can be represented using (almost) the smallest
    # possible bitmask.
    valvedata = sort(
        parse_line.(lines),
        lt=(t1, t2)->(t1[1] != "AA" && (t2[1] == "AA" || t1[2] < t2[2])),
        rev=true,
    )
    valveindices = Dict{String, Int}()
    flowrates = Vector{Int}(undef, valve_count)
    for (i, (name, rate, _)) in enumerate(valvedata)
        flowrates[i] = rate
        valveindices[name] = i
    end
    neighbors = Vector{Vector{Int}}(undef, valve_count)
    for (i, (_, _, valve_neighbors)) in enumerate(valvedata)
        neighbors[i] = [valveindices[n] for n in valve_neighbors]
    end
    return flowrates, neighbors
end

Input = Tuple{
    <:AbstractVector{<:Integer},
    <:AbstractVector{<:AbstractVector{<:Integer}}
}

struct State
    valveidx::Int
    valvestates::UInt64
    timeleft::Int
    playeridx::Int
end

function solve_part1(input::Input)
    (flowrates, neighbors) = input
    @assert sum(1 for rate in flowrates if rate != 0) <= 64
    lut = Dict{State, Int}()
    state = get_initial_state()
    return total_pressure!(lut, state, flowrates, neighbors)
end

function solve_part2(input::Input)
    (flowrates, neighbors) = input
    @assert sum(1 for rate in flowrates if rate != 0) <= 64
    lut = Dict{State, Int}()
    state = get_initial_state(playeridx=2, multiplay=true)
    return total_pressure!(lut, state, flowrates, neighbors)
end

function parse_line(line::AbstractString)
    regex = Regex(string(
        raw"^Valve ([A-Z]+) has flow rate=(\d+); ",
        raw"tunnels? leads? to valves? ([A-Z, ]+)$"
    ))
    captures = match(regex, line).captures
    valvename = captures[1]
    flowrate = parse(Int, captures[2])
    neighbors = split(captures[3], ", ")
    return valvename, flowrate, neighbors
end

function get_initial_state(;
    playeridx::Integer=1,
    multiplay::Bool=false,
    valvestates::UInt64=zero(UInt64),
)
    if multiplay
        return State(1, valvestates, 26, playeridx)
    else
        @assert playeridx == 1
        return State(1, valvestates, 30, 1)
    end
end

# Use a LUT, so previously evaluated states do not get re-evaluated in the
# recursion (dynamic programming).
#
# Part 2 remarks:
# - Maximal pressure is only achieved if two players head for a disjoint set of
# working valves.
# - It is not needed to simulate the actions of two players simultaneously. -
# Instead, a sequential approach can be taken: the actions of the second player
# (elephant) can be simulated on the set of working valves left closed by the
# first one.

function total_pressure!(
    lut::Dict{State, Int},
    state::State,
    flowrates::AbstractVector{<:Integer},
    neighbors::AbstractVector{<:AbstractVector{<:Integer}}
)
    i = state.valveidx
    valvestates = state.valvestates
    timeleft = state.timeleft
    playeridx = state.playeridx

    if timeleft == 0
        return playeridx == 1 ? 0 : total_pressure!(
            lut,
            get_initial_state(
                playeridx=playeridx - 1,
                multiplay=true,
                valvestates=valvestates,
            ),
            flowrates,
            neighbors,
        )
    end

    if haskey(lut, state)
        return lut[state]
    end

    # Get (i - 1)-th bit (1 for open)
    is_open = valvestates & (1 << (i - 1)) != 0
    flowrate = flowrates[i]

    result = 0

    # Consider the total pressure when opening the valve (if it works)
    if !is_open && flowrate > 0
        # Set (i - 1)-th bit to 1 (open)
        new_valvestates = valvestates | (1 << (i - 1))
        result = max(
            result,
            flowrate * (timeleft - 1) + total_pressure!(
                lut,
                State(i, new_valvestates, timeleft - 1, playeridx),
                flowrates,
                neighbors,
            )
        )
    end
    # Consider the total pressure when not touching the valve but moving on to
    # the neighboring valves
    for j in neighbors[i]
        result = max(
            result,
            total_pressure!(
                lut,
                State(j, valvestates, timeleft - 1, playeridx),
                flowrates,
                neighbors,
            )
        )
    end

    lut[state] = result
    return result
end

end # module
