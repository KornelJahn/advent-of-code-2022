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
        # DEBUG
        if id > 1
            break
        end
        println()
        println("Current id: $id")
        println()
        sum_quality_levels += (
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
    objective_function(s::State) = -projected_geode_count(s)
    prunable_(s::State, current_opt_val::Integer) = prunable(
        blueprint, s, -current_opt_val
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
            if kind == GEODE
                empty!(moves)
            end
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

function prunable(blueprint, state, current_max_geode_count)
    (res, rob, t) = unpack(state)

    prunable = false
    # Prune if projected geode count could not surpass current maximum even if
    # a new geode robot were assembled in each minute left
    prunable |= (
        (res[GEODE] + rob[GEODE] * t + div(t*(t - 1), 2))
        <= current_max_geode_count
    )
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
    cnt = 0
    push!(stack, root)
    while !isempty(stack)
        node = pop!(stack)
        cnt += 1
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
                end
                # Otherwise prune branch
            end
        end
    end
    println("Node count: $cnt")
    return current_optimum
end

end # module
