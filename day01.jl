using Test

abstract type PuzzlePartTrait end
struct Part{N} <: PuzzlePartTrait end

function parse_input(input::AbstractString)
    groupwise = split(strip(input), "\n\n")
    convert(group) = parse.(Ref(Int), split(strip(group), "\n"))
    return sum.(convert.(groupwise))
end

AbstractSums = AbstractVector{<:Integer}

function solve(::Part{1}, sums::AbstractSums)
    return maximum(sums)
end

function solve(::Part{2}, sums::AbstractSums)
    return sum(sort(sums, rev=true)[1:3])
end

function main()
    parsed = parse_input(read(ARGS[1], String))
    for part_idx in (1, 2)
        solution = solve(Part{part_idx}(), parsed)
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
    parsed = parse_input(input)
    @test solve(Part{1}(), parsed) == 24000
    @test solve(Part{2}(), parsed) == 45000
end

if length(ARGS) > 0
    main()
else
    test()
end
