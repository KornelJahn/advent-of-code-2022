module Day16

using DataStructures

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    valve_count = length(lines)
    # Order valves by decreasing flow rate so that states of working valves can
    # easily fit into a fixed-size bitmask. However, still put valve AA first
    # so that it is easier to index as the initial valve (by assuming for the
    # sake of comparison that it has the largest flowrate).
    valvedata = sort(
        parse_line.(lines),
        lt=(t1, t2)->(t1[1] != "AA" && (t2[1] == "AA" || <(t1[2], t2[2]))),
        rev=true
    )
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
    totalpressure::Int
end

const MAX_WORKING_VALVE_COUNT = sizeof(fieldtype(State, :valvestates)) * 8

function solve_part1(input::Input)
    (flowrates, neighbors) = input
    @assert sum(1 for rate in flowrates if rate != 0) <= MAX_WORKING_VALVE_COUNT
    state = get_initial_state()
    @time result = max_total_pressure(state, flowrates, neighbors)
    return result
end

function solve_part2(input::Input)
    (flowrates, neighbors) = input
    @assert sum(1 for rate in flowrates if rate != 0) <= MAX_WORKING_VALVE_COUNT
    lut = Dict{State, Int}()
    state = get_initial_state(playeridx=2, multiplay=true)
    return max_total_pressure(state, flowrates, neighbors)
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

function get_initial_state(
    playeridx::Integer=1,
    multiplay::Bool=false,
    valvestates::UInt64=zero(UInt64),
)
    @assert multiplay || playeridx == 1
    valveidx = 1
    timeleft = multiplay ? 26 : 30
    totalpressure = 0
    return State(valveidx, valvestates, timeleft, playeridx, totalpressure)
end

# Exhaustive iterative Depth-First Search for max value over the decision tree
# containing all states
function max_total_pressure(
    initialstate::State,
    flowrates::AbstractVector{<:Integer},
    neighbors::AbstractVector{<:AbstractVector{<:Integer}},
)
    lut = Dict{State, Int}()
    stack = Vector{State}()
    sizehint!(stack, length(flowrates))
    result = 0
    push!(stack, initialstate)
    while !isempty(stack)
        state = pop!(stack)
        if haskey(lut, state)
            result = lut[state]
        else
            result = max(result, state.totalpressure)
            lut[state] = result
            push_new_states!(stack, state, flowrates, neighbors)
        end
    end
    return result
end

# Part 2 observations:
# - It is clearly suboptimal if the elephant and me go for the same working
# valves.
# - The elephant and me could therefore agree beforehand to go for disjoint
# sets of working valves.
# - For all possible moves I have made, each resulting in a different history
# of opening valves, we examine all possible series of actions by the
# elephant.
# - It is therefore not needed to consider our actions simultaneously, we could
# consider it sequentially for the sake of optimization: we simply join the
# elephant decision tree at the end of each branch of my decision tree.
function push_new_states!(stack, state, flowrates, neighbors)
    valvestates = state.valvestates
    timeleft = state.timeleft
    playeridx = state.playeridx
    totalpressure = state.totalpressure
    i = state.valveidx

    if timeleft == 0
        # If time is over and there are multiple players, continue with the
        # decision tree of the next player given the outcome of the previous
        # player's moves
        if playeridx > 1
            multiplay = true
            push!(stack, get_initial_state(
                playeridx - 1,
                multiplay,
                valvestates,
            ))
        end
        return
    end

    # Get (i - 1)-th bit of the `valvestates` bitmask (1 if open)
    is_open = valvestates & (1 << (i - 1)) != 0
    flowrate = flowrates[i]

    if !is_open && flowrate > 0
        # Get (i - 1)-th bit of the `valvestates` bitmask to 1 (open)
        new_valvestates = valvestates | (1 << (i - 1))
        push!(stack, State(
            i,
            new_valvestates,
            timeleft - 1,
            playeridx,
            totalpressure + flowrate * (timeleft - 1),
        ))
        return
    end

    for j in neighbors[i]
        push!(stack, State(
            j,
            valvestates,
            timeleft - 1,
            playeridx,
            totalpressure,
        ))
    end
end

end # module
