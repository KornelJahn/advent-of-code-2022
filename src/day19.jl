module Day19

using DataStructures

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    regex = Regex(
        raw"Blueprint \d+: " *
        raw"Each ore robot costs (\d+) ore. " *
        raw"Each clay robot costs (\d+) ore. " *
        raw"Each obsidian robot costs (\d+) ore and (\d+) clay. " *
        raw"Each geode robot costs (\d+) ore and (\d+) obsidian."
    )
    rawcosts = [
        parse.(Ref(Int), match(regex, line).captures) for line in lines
    ]
    return [
        [
            # ore   clay   obs.   geode
            (rc[1], 0,     0,     0), # ore robot
            (rc[2], 0,     0,     0), # clay robot
            (rc[3], rc[4], 0,     0), # obsidian robot
            (rc[5], 0,     rc[6], 0), # geode robot
        ]
        for rc in rawcosts
    ]
end

const AbstractBlueprint = AbstractVector{<:NTuple{4, <:Integer}}
const Input = AbstractVector{<:AbstractBlueprint}

struct State
    resources::NTuple{4, Int}
    robots::NTuple{4, Int}
    timeleft::Int
end

function solve_part1(blueprints::Input)
    initial_state = State((0, 0, 0, 0), (1, 0, 0, 0), 20)
    sum_quality_levels = 0
    for (id, blueprint) in enumerate(blueprints)
        # DEBUG
        if id > 1
            break
        end
        println()
        println("Current id: $id")
        println()
        @time sum_quality_levels += (
            id * max_geode_count(blueprint, initial_state)
        )
    end
    return sum_quality_levels
end

function solve_part2(::Input)
    return nothing
end

const ORE = 1
const CLAY = 2
const OBSIDIAN = 3
const GEODE = 4

function max_geode_count(blueprint, initial_state)
    blueprint_max_costs = [
        max(single_res_costs...)
        for single_res_costs in zip(blueprint...)
    ]
    objective_function(s::State) = -s.resources[GEODE]
    pruning_predicate(s::State, current_opt_val::Integer) = prunable(
        blueprint, blueprint_max_costs, s, -current_opt_val
    )
    isleaf(s::State) = s.timeleft == 0
    getchildren!(s::State, children::AbstractVector{State}) = possible_moves!(
        blueprint, s, children
    )

    return -objective_function(dfs_solve_pruning(
        initial_state,
        objective_function,
        pruning_predicate,
        isleaf,
        getchildren!,
    ))
end

function possible_moves!(blueprint, state, moves)
    empty!(moves)
    # Harvest only
    push!(moves, State(
        state.resources .+ state.robots,
        state.robots,
        state.timeleft - 1
    ))
    # Build robot and harvest
    for (kind, cost) in enumerate(blueprint)
        if all(state.resources .- cost .>= 0)
            push!(moves, State(
                state.resources .+ state.robots .- cost,
                state.robots .+ unit(kind),
                state.timeleft - 1
            ))
        end
    end
    return moves
end

unit(i::T) where {T<:Integer} = NTuple{4, Int}(j == i ? 1 : 0 for j in 1:4)

function prunable(blueprint, blueprint_max_costs, state, current_max_geode_count)
    t = state.timeleft
    res = state.resources
    rob = state.robots

    prunable = false
    # Prune if projected geode count could not surpass current maximum even if
    # a new geode robot were assembled in each minute left
    prunable |= (
        (res[GEODE] + rob[GEODE] * t + div(t*(t + 1), 2))
        <= current_max_geode_count
    )
    # Prune if stacking resources is detected, i.e. the number of a particular
    # kind of robot is greater than the maximal amount of resources needed for
    # any other robot
    prunable |= any(rob .> blueprint_max_costs)
    # Prune if a geode robot is not bought despite enough resources available
    prunable |= all(res .> blueprint[GEODE])

    return prunable
end

# General function for minimization (TODO: refactor into external module?)
function dfs_solve_pruning(
    root,
    objective_function::Function,
    pruning_predicate::Function,
    isleaf::Function,
    getchildren!::Function,
    max_child_count::Integer = 0
)
    current_optimum_value = typemax(Int)
    current_optimum = root
    stack = Vector{typeof(root)}()
    children = Vector{typeof(root)}()
    if max_child_count > 0
        sizehint!(children, max_child_count)
    end
    push!(stack, root)
    while !isempty(stack)
        node = pop!(stack)
        if isleaf(node)
            current_value = objective_function(node)
            if current_value < current_optimum_value
                current_optimum = node
                current_optimum_value = current_value
            end
        else
            getchildren!(node, children)
            for child in children
                if !pruning_predicate(child, current_optimum_value)
                    push!(stack, child)
                end
                # Otherwise prune branch
            end
        end
    end
    return current_optimum
end

end # module
