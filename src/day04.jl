module Day04

function parse_input(raw::AbstractString)
    regex = r"^(\d+)-(\d+),(\d+)-(\d+)$"
    lines = split(strip(raw), "\n")
    sections = Array{Int}(undef, 4, length(lines))
    for (i, line) in enumerate(lines)
        sections[:, i] = parse.(Ref(Int), match(regex, line).captures)
    end
    return sections
end

Input = AbstractArray{<:Integer, 2}

solve_part1(sections::Input) = calc_total(sections, are_fully_overlapping)

solve_part2(sections::Input) = calc_total(sections, are_overlapping)

function calc_total(sections::Input, overlap_pred::Function)
    return sum(overlap_pred(col...) for col in eachcol(sections))
end

function are_fully_overlapping(a::T, b::T, c::T, d::T) where {T<:Integer}
    # TODO: could this be more efficient by direct logical comparisons?
    return (max(a, c), min(b, d)) in [(a, b), (c, d)]
end

function are_overlapping(a::T, b::T, c::T, d::T) where {T<:Integer}
    return max(a, c) <= min(b, d)
end

end # module
