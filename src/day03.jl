module Day3

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a vector of lines.
"""
parse_input(::Day{3}, raw::AbstractString) = split(strip(raw), "\n")

AbstractInput = AbstractVector{<:AbstractString}

function solve(::Day{3}, part::PartTrait, input::AbstractInput)
    return sum(iter_priorities(part, input))
end

"""
Iterate over common item priorities.
"""
function iter_priorities(part::PartTrait, lines::AbstractInput)
    Channel() do channel
        for containers in iter_rucksacks(part, lines)
            common_item = find_common_item(containers...)
            priority = assign_priority(common_item)
            push!(channel, priority)
        end
    end
end

"""
Iterate over compartment pairs of the rucksacks for the 1st part of the puzzle.
"""
function iter_rucksacks(::Part{1}, lines::AbstractInput)
    Channel() do channel
        for line in lines
            mid = div(length(line), 2)
            push!(channel, (line[begin:mid], line[(mid+1):end]))
        end
    end
end

"""
Iterate over rucksack groups of 3 for the 2nd part of the puzzle.
"""
function iter_rucksacks(::Part{2}, lines::AbstractInput; group_size=3)
    return Iterators.partition(lines, 3)
end

"""
Find single common item in containers (rucksacks or their compartments).
"""
function find_common_item(containers::AbstractString...)
    sets = (Set(container) for container in containers)
    common_items = intersect(sets...)
    @assert length(common_items) == 1
    return pop!(common_items)
end

"""
Assign priority to an item.
"""
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
