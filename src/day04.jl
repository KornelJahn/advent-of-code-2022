module Day04

AbstractInput = AbstractArray{<:Integer, 2}

function parse_input(raw::AbstractString)
    regex = r"^(\d+)-(\d+),(\d+)-(\d+)$"
    lines = split(strip(raw), "\n")
    input = Array{Int}(undef, 4, length(lines))
    for (i, line) in enumerate(lines)
        input[:, i] = parse.(Ref(Int), match(regex, line).captures)
    end
    return input
end

solve_part1(input::AbstractInput) = sum(
    are_fully_overlapping(col...) for col in eachcol(input)
)

solve_part2(input::AbstractInput) = sum(
    are_overlapping(col...) for col in eachcol(input)
)

function are_fully_overlapping(a::T, b::T, c::T, d::T) where {T<:Integer}
    return (max(a, c), min(b, d)) in [(a, b), (c, d)]
end

function are_overlapping(a::T, b::T, c::T, d::T) where {T<:Integer}
    return max(a, c) <= min(b, d)
end

end # module
