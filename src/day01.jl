module Day01

AbstractInput = AbstractVector{<:AbstractVector{<:Integer}}

function parse_input(raw::AbstractString)
    groups = split(strip(raw), "\n\n")
    convert(group) = parse.(Ref(Int), split(strip(group), "\n"))
    return convert.(groups)
end

solve_part1(input::AbstractInput) = maximum(sum.(input))

solve_part2(input::AbstractInput) = sum(sort(sum.(input), rev=true)[1:3])

end # module
