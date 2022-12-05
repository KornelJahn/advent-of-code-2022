include("../src/AdventOfCode2022.jl")

using Test
using .Puzzle: Day, Part

const ASSETSDIR = "$(@__DIR__)/../assets"
const LAST_DAY = 4

const solutions = Dict{String, Array{Int, 2}}(
    "example" => [
        24000 45000; # Day 01
        15 12;       # Day 02
        157 70;      # Day 03
        2 4;         # Day 04
    ],
    "real" => [
        65912 195625; # Day 01
        10816 11657;  # Day 02
        8153 2342;    # Day 03
        475 825;      # Day 04
    ],
)

@testset "Advent of Code 2022" begin
    for day in 1:LAST_DAY
        for kind in ("example", "real")
            @testset "Day $day, $kind input" begin
                daystr = string(day, base=10, pad=2)
                day_trait = Day{day}()
                input = parse_input(
                    day_trait,
                    read("$ASSETSDIR/day$(daystr)_$(kind).txt", String)
                )
                for part in (1, 2)
                    part_trait = Part{part}()
                    obtained = solve(day_trait, part_trait, input)
                    expected = solutions[kind][day, part]
                    @test obtained == expected
                end # for
            end # testset
        end # for
    end # for
end # testset
