module Day01

function parse_input(raw::AbstractString)
    groups = split(strip(raw), "\n\n")
    return [parse.(Ref(Int), split(strip(group), '\n')) for group in groups]
end

Input = AbstractVector{<:AbstractVector{<:Integer}}

solve_part1(elf_calories::Input) = maximum(sum.(elf_calories))

solve_part2(elf_calories::Input) = sum(sort(sum.(elf_calories), rev=true)[1:3])

end # module
