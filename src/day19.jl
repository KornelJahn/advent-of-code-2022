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
    initial_state = State((0, 0, 0, 0), (1, 0, 0, 0), 24)
    sum_quality_levels = 0
    for (id, blueprint) in enumerate(blueprints)
        println()
        println("Current id: $id")
        gc = max_geode_count(blueprint, initial_state)
        println("Max geode count: $gc")
        println()
        sum_quality_levels += id * gc
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
    blueprint_max_costs = Tuple(
        max(single_res_costs...)
        for single_res_costs in zip(blueprint...)
    )[1:3]
    objective_function(s::State) = -projected_geode_count(s)
    prunable_(s::State, current_opt_val::Integer) = prunable(
        blueprint, blueprint_max_costs, s, -current_opt_val
    )
    getchildren!(s::State, children::AbstractVector{State}) = feasible_moves!(
        blueprint, s, children
    )

    return -objective_function(dfs_solve_pruning(
        initial_state,
        objective_function,
        prunable_,
        getchildren!,
    ))
end

@inline unpack(state::State) = (state.resources, state.robots, state.timeleft)

function projected_geode_count(state::State)
    (res, rob, t) = unpack(state)
    return res[GEODE] + rob[GEODE] * t
end

function feasible_moves!(blueprint, state, moves)
    empty!(moves)
    (res, rob, t) = unpack(state)
    # Do not build in the last minute
    if t <= 1
        return
    end
    for (kind, cost) in enumerate(blueprint)
        # Build the robot is possible and advance in time
        buildable = all(@. cost <= (res + rob * t))
        if buildable
            # If possible to build a geode robot, this should be the only
            # option
            # if kind == GEODE
            #     empty!(moves)
            # end
            treq = max(
                cld.(cost .- res, ifelse.(rob .== 0, typemax(Int), rob))...
            )
            @assert treq <= t
            push!(moves, State(
                res .+ rob .* treq .- cost,
                rob .+ unit(kind),
                t - treq
            ))
        end
    end
end

unit(i::T) where {T<:Integer} = NTuple{4, Int}(j == i ? 1 : 0 for j in 1:4)

function prunable(
    blueprint,
    blueprint_max_costs,
    state,
    current_max_geode_count,
)
    (res, rob, t) = unpack(state)

    prunable = false
    # Prune if projected geode count could not surpass current maximum even if
    # a new geode robot were assembled in each minute left
    prunable |= (
        (res[GEODE] + rob[GEODE] * t + div(t*(t - 1), 2))
        <= current_max_geode_count
    )
    # Prune if the number of ore, clay, and obsidian robots is greater than the
    # maximal amount of resources needed for any other robot
    prunable |= any(rob[1:3] .> blueprint_max_costs)
    return prunable
end

# General function for minimization (TODO: refactor into external module?)
function dfs_solve_pruning(
    root,
    objective_function::Function,
    prunable::Function,
    getchildren!::Function,
    max_child_count::Integer = 4
)
    current_optimum_value = typemax(Int)
    current_optimum = root
    stack = Vector{typeof(root)}()
    children = Vector{typeof(root)}()
    if max_child_count > 0
        sizehint!(children, max_child_count)
    end
    total = 0
    pruned = 0
    push!(stack, root)
    while !isempty(stack)
        node = pop!(stack)
        total += 1
        getchildren!(node, children)
        if isempty(children)
            current_value = objective_function(node)
            if current_value < current_optimum_value
                current_optimum = node
                current_optimum_value = current_value
            end
        else
            for child in children
                if !prunable(child, current_optimum_value)
                    push!(stack, child)
                else
                    # Otherwise prune branch
                    pruned += 1
                end
            end
        end
    end
    println("Total node count: $total")
    println("Pruned node count: $pruned")
    return current_optimum
end

end # module
