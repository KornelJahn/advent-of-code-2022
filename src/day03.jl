module Day3

export parse_input, solve

using .Iterators: partition
using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

AbstractInput = AbstractVector{<:AbstractString}

parse_input(::Day{3}, raw::AbstractString) = split(strip(raw), "\n")

solve(::Day{3}, part::PartTrait, input::AbstractInput) = sum(
    iter_priorities(part, input)
)

iter_priorities(part::PartTrait, input::AbstractInput) = Channel() do ch
    for containers in iter_rucksacks(part, input)
        common_item = find_common_item(containers...)
        priority = assign_priority(common_item)
        put!(ch, priority)
    end
end

iter_rucksacks(::Part{1}, lines::AbstractInput) = Channel() do ch
    for line in lines
        mid = div(length(line), 2)
        put!(ch, (line[1:mid], line[(mid+1):end]))
    end
end

iter_rucksacks(::Part{2}, lines::AbstractInput) = partition(lines, 3)

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
