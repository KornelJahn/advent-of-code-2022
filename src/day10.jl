module Day10

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')

    function convert_line(line::AbstractString)
        instr, args = Iterators.peel(split(line))
        PARSERS = Dict(
            "noop" => ()->0,
            "addx" => arg->parse(Int, arg),
        )
        return instr, PARSERS[instr](args...)
    end

    return map(convert_line, lines)
end

Input = AbstractVector{<:Tuple{<:AbstractString, <:Any}}

function solve_part1(instructions::Input)
    Xs = convert_to_register_values(instructions)
    cycles = 20:40:220
    return sum(cycles .* Xs[cycles])
end

function solve_part2(instructions::Input)
    Xs = convert_to_register_values(instructions)
    return draw_screen_output(Xs)
end

function convert_to_diffs(instr::AbstractString, arg::Int = 0)
    EFFECTS = Dict("noop" => x->(0,), "addx" => x->(0, x))
    return EFFECTS[instr](arg)
end

# Assume eltype of iterables is the same
cat(iterables...) = Iterators.flatten(iterables)

function convert_to_register_values(instructions::Input)
    initial = 1
    diffs = Iterators.flatten(
        convert_to_diffs(instr...) for instr in instructions
    )
    return collect(cat((initial,), accumulate(+, diffs, init=initial)))
end

function draw_screen_output(
    Xs::AbstractVector{<:Integer};
    width::Integer=40,
    height::Integer=6
)
    cycles = 0:(width*height - 1)
    draw_single(cycle, X) = mod(cycle, 40) in (X-1):(X+1) ? '#' : '.'
    linear_output = (draw_single(cycle, X) for (cycle, X) in zip(cycles, Xs))
    lines = prod.(Iterators.partition(linear_output, width))
    return join(lines, '\n')
end

end # module
