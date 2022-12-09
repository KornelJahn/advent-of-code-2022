module Day9

export parse_input, solve

using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

AbstractInput = AbstractVector{
    <:Tuple{<:Tuple{<:Integer, <:Integer}, <:Integer}
}

const DIRECTIONS = Dict(
    'U' => (0, 1),
    'D' => (0, -1),
    'L' => (-1, 0),
    'R' => (1, 0),
)

function parse_input(::Day{9}, raw::AbstractString)
    function convert_line(l)
        (rawdir, rawcnt) = split(l)
        return DIRECTIONS[rawdir[1]], parse(Int, rawcnt)
    end
    lines = split(strip(raw), '\n')
    return convert_line.(lines)
end

function solve(::Day{9}, ::Part{1}, input::AbstractInput)
    head_history = head_positions(input)
    return length(unique(tail_positions(head_history)))
end

# FIXME: this logic is unfortunately wrong
function solve(::Day{9}, ::Part{2}, input::AbstractInput; taillen::Int = 9)
    head_history = head_positions(input)
    tail_histories = accumulate(
        (hist, _)->tail_positions(hist),
        1:taillen,
        init=head_history
    )
    print_rope_history(head_history, tail_histories...)
    return length(unique(tail_histories[end]))
end

AbstractPos = Tuple{<:Integer, <:Integer}

function tail_positions(head_history::AbstractVector{<:AbstractPos})
    tail_history = [(0, 0)]
    for (head_prev, head) in zip(head_history, head_history[2:end])
        push!(tail_history, next_tail(tail_history[end], head_prev, head))
    end
    return tail_history
end

function head_positions(input::AbstractInput)
    heads = [(0, 0)]
    append!(
        heads,
        accumulate(
            .+,
            Iterators.flatten(map(args->Iterators.repeated(args...), input)),
            init=heads[end]
        )
    )
    return heads
end

function next_tail(
    tail::AbstractPos,
    head_prev::AbstractPos,
    head::AbstractPos,
)
    return distance_squared(head, tail) > 2 ? head_prev : tail
end

distance_squared(p::AbstractPos, q::AbstractPos) = sum((p .- q).^2)

function print_rope_history(histories...)
    CHARS = "987654321H"
    # FIXME: fixed size based on global extrema
    for step in 1:length(histories[1])
        points = [h[step] for h in Iterators.reverse(histories)]
        (xmin, xmax) = extrema(p[1] for p in points)
        (ymin, ymax) = extrema(p[2] for p in points)
        Nx = xmax - xmin + 1
        Ny = ymax - ymin + 1
        A = fill('.', Ny, Nx)
        A[-ymin + 1, -xmin + 1] = 's'
        for (i, (x, y)) in enumerate(points)
            A[y - ymin + 1, x - xmin + 1] = CHARS[i]
        end
        A = reverse(A, dims=1)
        println("Step $step\n")
        for row in eachrow(A)
            println(prod(row))
        end
        println()
    end
end

end # module
