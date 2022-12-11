module Day05

AbstractCrateStack = AbstractVector{<:AbstractChar}

AbstractInput = Tuple{
    <:AbstractVector{<:AbstractCrateStack},
    <:AbstractArray{<:Integer, 2}
}

function parse_input(raw::AbstractString)
    (raw_stacks, raw_instructions) = split(raw, "\n\n")
    return parse_stacks(raw_stacks), parse_instructions(raw_instructions)
end

solve_part1(input::AbstractInput) = rearranged_top_crates(input, order_part1)

solve_part2(input::AbstractInput) = rearranged_top_crates(input, order_part2)

function rearranged_top_crates(input::AbstractInput, order_func)
    (stacks, instructions) = input
    stacks = deepcopy(stacks)
    for instruction in eachcol(instructions)
        (qty, source, target) = instruction
        N = length(stacks[source])
        transferred = order_func(splice!(stacks[source], (N-qty+1):N))
        append!(stacks[target], transferred)
    end
    return string((stack[end] for stack in stacks)...)
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

function parse_instructions(raw::AbstractString)
    lines = split(strip(raw), "\n")
    regex = r"^move (\d+) from (\d+) to (\d+)$"
    instructions = Array{Int}(undef, 3, length(lines))
    for (i, line) in enumerate(lines)
        instructions[:, i] = parse.(Ref(Int), match(regex, line).captures)
    end
    return instructions
end

order_part1(crates::AbstractCrateStack) = reverse(crates)

order_part2(crates::AbstractCrateStack) = crates

end # module
