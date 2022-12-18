module Day16

using DataStructures

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    valve_count = length(lines)
    # Do lexicographic ordering on valve names, so AA valve comes first
    valvedata = sort(parse_line.(lines), by=tup->tup[1])
    valvenames = Vector{String}(undef, valve_count)
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

    # Maximal pressure is achieved if two players work simultaneously but open
    # different valves. From the viewpoint of the optimum, it makes no
    # difference if players work simultaneously or sequentially. Simulate the
    # latter as it is easy to add to the recursion.
    if timeleft == 0
        if playeridx > 1
            return total_pressure!(
                lut,
                get_initial_state(
                    playeridx=playeridx-1,
                    multiplay=true,
                    valvestates=valvestates,
                ),
                flowrates,
                neighbors,
            )
        else
            return 0
        end
    end

    if haskey(lut, state)
        return lut[state]
    end

    # Get (i - 1)-th bit (1 for open)
    is_open = valvestates & (1 << (i - 1)) != 0
    flowrate = flowrates[i];

    result = 0

    # Calculate total pressure when opening the valve (if it is working)
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
    # Calculate total pressure when not touching the valve but moving on to
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
