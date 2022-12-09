module Day9

export parse_input, solve

using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

AbstractInput = AbstractVector{<:Tuple{<:AbstractChar, <:Integer}}

function parse_input(::Day{9}, raw::AbstractString)
    function convert_line(l)
        (rawdir, rawcnt) = split(l)
        return Char(rawdir[1]), parse(Int, rawcnt)
    end
    lines = split(strip(raw), '\n')
    return convert_line.(lines)
end

# FIXME: does not give correct answer for real input!
function solve(::Day{9}, ::Part{1}, input::AbstractInput)
    return length(unique(tail_positions(input)))
end

function solve(::Day{9}, ::Part{2}, input::AbstractInput)
    return nothing
end

function tail_positions(input::AbstractInput)
    DIRECTIONS = Dict(
        'U' => [0, 1],
        'D' => [0, -1],
        'L' => [-1, 0],
        'R' => [1, 0],
    )
    tail_positions = Vector{Vector{Int}}()
    head_position = [0, 0]
    for (dir, cnt) in input
        append!(
            tail_positions,
            accumulate(
                .+,
                Iterators.repeat(DIRECTIONS[dir], cnt - 1),
                init=head_position
            )
        )
        head_position += DIRECTIONS[dir]
    end
    return tail_positions
end

end # module
