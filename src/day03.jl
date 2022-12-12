module Day03

parse_input(raw::AbstractString) = split(strip(raw), "\n")

Input = AbstractVector{<:AbstractString}

solve_part1(rucksacks::Input) = sum(priorities(compartments(rucksacks)))

solve_part2(rucksacks::Input) = sum(priorities(groups(rucksacks)))

priorities(item_groups) = Channel() do ch
    for group in item_groups
        common_item = find_common_item(group...)
        priority = assign_priority(common_item)
        put!(ch, priority)
    end
end

compartments(lines::Input) = Channel() do ch
    for line in lines
        mid = div(length(line), 2)
        put!(ch, (line[1:mid], line[(mid+1):end]))
    end
end

groups(lines::Input) = Iterators.partition(lines, 3)

function find_common_item(item_strings::AbstractString...)
    sets = (Set(s) for s in item_strings)
    common_items = intersect(sets...)
    @assert length(common_items) == 1
    return pop!(common_items)
end

function assign_priority(item::Char)
    if 'a' <= item <= 'z'
        return Int(item) - Int('a') + 1
    elseif 'A' <= item <= 'Z'
        return Int(item) - Int('A') + 27
    else
        throw(ArgumentError("invalid item: $item"))
    end
end

end # module
