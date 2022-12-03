using Test

abstract type PuzzlePartTrait end
struct Part{N} <: PuzzlePartTrait end

AbstractLines = AbstractVector{<:AbstractString}

"""
Iterate over the sums of calories for each elf.
"""
function iter_sums(lines::AbstractLines)
    total::Int = 0
    Channel() do channel
        for line in lines
            if isempty(line)
                push!(channel, total)
                total = 0
            else
                total += parse(typeof(total), line)
            end
        end
        if total > 0
            push!(channel, total)
        end
    end
end

"""Find the maximal sum of calories."""
find_maximal_sum(lines::AbstractLines) = maximum(iter_sums(lines))

"""
Find the three greatest sums of calories.
"""
function find_three_greatest_sums(lines::AbstractLines)
    sort(collect(iter_sums(lines)), rev=true)[1:3]
end

function solve(::Part{1}, lines::AbstractLines)
    return find_maximal_sum(lines)
end

function solve(::Part{2}, lines::AbstractLines)
    return sum(find_three_greatest_sums(lines))
end

function main()
    for part_idx in (1, 2)
        solution = solve(Part{part_idx}(), readlines(ARGS[1], keep=false))
        println("Solution (part $part_idx): $solution")
    end
end

function test()
    input = """
        1000
        2000
        3000

        4000

        5000
        6000

        7000
        8000
        9000

        10000
        """
    lines = split(input, keepempty=true)[begin:(end-1)]
    @test solve(Part{1}(), lines) == 24000
    @test solve(Part{2}(), lines) == 45000
end

if length(ARGS) > 0
    main()
else
    test()
end
