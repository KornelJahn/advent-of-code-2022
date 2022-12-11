module Day03

AbstractInput = AbstractVector{<:AbstractString}

parse_input(raw::AbstractString) = split(strip(raw), "\n")

solve_part1(input::AbstractInput) = sum(
    iter_priorities(iter_groups_part1(input))
)

solve_part2(input::AbstractInput) = sum(
    iter_priorities(iter_groups_part2(input))
)

iter_priorities(groups) = Channel() do ch
    for group in groups
        common_item = find_common_item(group...)
        priority = assign_priority(common_item)
        put!(ch, priority)
    end
end

iter_groups_part1(lines::AbstractInput) = Channel() do ch
    for line in lines
        mid = div(length(line), 2)
        put!(ch, (line[1:mid], line[(mid+1):end]))
    end
end

iter_groups_part2(lines::AbstractInput) = Iterators.partition(lines, 3)

function find_common_item(containers::AbstractString...)
    sets = (Set(container) for container in containers)
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
