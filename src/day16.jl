module Day16

using DataStructures

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    valve_count = length(lines)
    # Order valves by decreasing flow rate with the exception of valve AA which
    # comes first. This way, the states of relevant valves (working ones + AA)
    # can easily fit into a fixed-size bitmask.
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

AbstractFlowRates = AbstractVector{<:Integer}
AbstractNeighbors = AbstractVector{<:AbstractVector{<:Integer}}
AbstractDists = AbstractArray{<:Integer, 2}
Input = Tuple{<:AbstractFlowRates, <:AbstractNeighbors}

struct State
    valveidx::Int
    valvestates::UInt64
    timeleft::Int
    playeridx::Int
end

function solve_part1(input::Input)
    (dists, flowrates) = filter_relevant_valves(input)
    return max_total_pressure(dists, flowrates)
end

function solve_part2(input::Input)
    return nothing
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

function filter_relevant_valves(input::Input)
    (flowrates, neighbors) = input
    # Calculate the number of relevant valves (AA and those with nonzero rate)
    dists = convert_neighbors_to_dists(neighbors)
    dists = floyd_warshall(dists)
    (flowrates, neighbors_dists) = reduce_problem(flowrates, dists)
end

function convert_neighbors_to_dists(neighbors::AbstractNeighbors)
    n = length(neighbors)
    dists = fill(typemax(Int), (n, n))
    for i in 1:n
        dists[i, i] = 0
        for j in neighbors[i]
            dists[i, j] = 1
        end
    end
    return dists
end

function floyd_warshall(dists::AbstractDists)
    n = size(dists, 1)
    @assert size(dists, 2) == n
    for k in 1:n
        for i in 1:n
            for j in 1:n
                s = dists[i, k] + dists[k, j]
                # Handle integer overflow
                s = s < 0 ? typemax(Int) : s
                dists[i, j] = min(s, dists[i, j])
            end
        end
    end
    return dists
end

function reduce_problem()
    # Reduce problem to essential valves
    n = findfirst(==(0), flowrates[2:end])
    flowrates = flowrates[1:n]
    @views return dists[1:n, 1:n], flowrates[1:n]
end

function branch_and_bound_solve(
    initial_state::State,
    dists::AbstractDists,
    flowrates::AbstractFlowRates,
)
    lower_bound = 0
    candidate_queue = Queue{State}()
    enqueue!(candidate_queue, initial_state)
    while !isempty(candidate_queue)
        state = dequeue!(candidate_queue)
        if isfinal(state)
            utility = utility_function(node)
            if utility > lower_bound
                current_optimum = node
                lower_bound = utility
            end
        else
            for child_branch in getchildren(node)
                if upper_bound_funcion(child_branch) >= lower_bound
                    enqueue!(candidate_queue, child_branch)
                end
            end
        end
    end
    return current_optimum
end

function isfinal(state::State, dists::AbstractDists)
    return all(
        state.timeleft < d+1 for (_, d) in closed_neighbors(state, dists)
    )
end

function closed_neighbors(state::State, dists::AbstractDists)
    return []
end

function isclosed(valvestates::Int64, valveidx::Int)
    return 
end

function max_total_pressure(
)
end

function upper_bound(
    state::State,
    dists::AbstractDists,
    flowrates::AbstractFlowRates,
)

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

end # module
