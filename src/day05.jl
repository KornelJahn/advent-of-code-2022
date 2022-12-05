module Day5

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return crate stacks as a vector containing vectors of characters and movement
rules as a 2D array of integers, with columns as containing the crate quantity,
and source and target stacks, respectively.
"""
function parse_input(::Day{5}, raw::AbstractString)
    (raw_stacks, raw_rules) = split(raw, "\n\n")
    return parse_stacks(raw_stacks), parse_rules(raw_rules)
end

function parse_stacks(raw::AbstractString)
    lines = split(raw, "\n")
    stack_count = parse(Int, split(strip(lines[end]))[end])
    # NOTE: a Deque from DataStructures.jl would be more efficient
    stacks = Vector{Vector{Char}}(undef, stack_count)
    for i in 1:stack_count
        stacks[i] = Vector{Char}(undef, 0)
    end
    for line in lines[begin:(end-1)]
        crates = line[2:4:end]
        for (i, crate) in enumerate(crates)
            if crate != ' '
                pushfirst!(stacks[i], crate)
            end
        end
    end
    return stacks
end

function parse_rules(raw::AbstractString)
    lines = split(strip(raw), "\n")
    regex = r"^move (\d+) from (\d+) to (\d+)$"
    rules = Array{Int}(undef, 3, length(lines))
    for (i, line) in enumerate(lines)
        rules[:, i] = parse.(Ref(Int), match(regex, line).captures)
    end
    return rules
end

AbstractInput = Tuple{
    <:AbstractVector{<:AbstractVector{<:AbstractChar}},
    <:AbstractArray{<:Integer, 2}
}

function solve(::Day{5}, part::PartTrait, input::AbstractInput)
    (stacks, rules) = input
    stacks = deepcopy(stacks)
    for rule in eachcol(rules)
        (qty, source, target) = rule
        N = length(stacks[source])
        transferred = order(part, splice!(stacks[source], (N-qty+1):N))
        append!(stacks[target], transferred)
    end
    return string((stack[end] for stack in stacks)...)
end

# CrateMover 9000
order(::Part{1}, crates::AbstractVector{<:AbstractChar}) = reverse(crates)

# CrateMover 9001
order(::Part{2}, crates::AbstractVector{<:AbstractChar}) = crates

end # module
