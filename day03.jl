using Test

abstract type PuzzlePartTrait end
struct Part{N} <: PuzzlePartTrait end

AbstractLines = AbstractVector{<:AbstractString}

"""
Iterate over compartment pairs of the rucksacks for the 1st part of the puzzle.
"""
function iter_rucksacks(::Part{1}, lines::AbstractLines)
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
function iter_rucksacks(::Part{2}, lines::AbstractLines; group_size=3)
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

"""
Iterate over common item priorities.
"""
function iter_priorities(part::PuzzlePartTrait, lines::AbstractLines)
    Channel() do channel
        for containers in iter_rucksacks(part, lines)
            common_item = find_common_item(containers...)
            priority = assign_priority(common_item)
            push!(channel, priority)
        end
    end
end

function solve(part::PuzzlePartTrait, lines::AbstractLines)
    return sum(iter_priorities(part, lines))
end

function main()
    input = readlines(ARGS[1], keep=false)
    for part_idx in (1, 2)
        solution = solve(Part{part_idx}(), input)
        println("Solution (part $part_idx): $solution")
    end
end

function test()
    raw = """
        vJrwpWtwJgWrhcsFMMfFFhFp
        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        PmmdzqPrVvPwwTWBwg
        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        ttgJtRGJQctTZtZT
        CrZsJsPPZsGzwwsLwLmpwMDw
        """
    input = split(raw, keepempty=true)[begin:(end-1)]
    @test solve(Part{1}(), input) == 157
    @test solve(Part{2}(), input) == 70
end

if length(ARGS) > 0
    main()
else
    test()
end
