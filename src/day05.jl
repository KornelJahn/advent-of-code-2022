module Day05

function parse_input(raw::AbstractString)
    (raw_stacks, raw_instructions) = split(raw, "\n\n")
    return parse_stacks(raw_stacks), parse_instructions(raw_instructions)
end

AbstractCrateStack = AbstractVector{<:AbstractChar}
AbstractCrateStacks = AbstractVector{<:AbstractCrateStack}
AbstractInstructions = AbstractArray{<:Integer, 2}
Input = Tuple{<:AbstractCrateStacks, <:AbstractInstructions}

solve_part1(input::Input) = rearrange_top_crates(order_9000, input...)

solve_part2(input::Input) = rearrange_top_crates(order_9001, input...)

function parse_stacks(raw::AbstractString)
    lines = split(raw, "\n")
    stack_count = parse(Int, split(strip(lines[end]))[end])
    stacks = Vector{Vector{Char}}(undef, stack_count)
    for i in 1:stack_count
        stacks[i] = Vector{Char}(undef, 0)
    end
    for line in lines[1:(end-1)]
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

function rearrange_top_crates(
    order_func::Function,
    stacks::AbstractCrateStacks,
    instructions::AbstractInstructions,
)
    stacks = deepcopy(stacks)
    for instruction in eachcol(instructions)
        (qty, source, target) = instruction
        N = length(stacks[source])
        transferred = order_func(splice!(stacks[source], (N-qty+1):N))
        append!(stacks[target], transferred)
    end
    return string((stack[end] for stack in stacks)...)
end

order_9000(crates::AbstractCrateStack) = reverse(crates)

order_9001(crates::AbstractCrateStack) = crates

end # module
