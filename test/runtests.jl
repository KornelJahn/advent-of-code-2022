include("../src/AdventOfCode2022.jl")

using Test
using .Puzzle: Day, Part

const ASSETSDIR = "$(@__DIR__)/../assets"
const DAY_RANGE = parse(Int, get(ARGS, 1, "1")):25

const solutions = Dict{String, Array{Any, 2}}(
    "example" => [
        24000 45000; # Day 01
        15 12; # Day 02
        157 70; # Day 03
        2 4; # Day 04
        "CMZ" "MCD"; # Day 05
        (7, 5, 6, 10, 11) (19, 23, 23, 29, 26); # Day 06
        95437 nothing; # Day 07
        nothing nothing; # Day 08
        nothing nothing; # Day 09
        nothing nothing; # Day 10
        nothing nothing; # Day 11
        nothing nothing; # Day 12
        nothing nothing; # Day 13
        nothing nothing; # Day 14
        nothing nothing; # Day 15
        nothing nothing; # Day 16
        nothing nothing; # Day 17
        nothing nothing; # Day 18
        nothing nothing; # Day 19
        nothing nothing; # Day 20
        nothing nothing; # Day 21
        nothing nothing; # Day 22
        nothing nothing; # Day 23
        nothing nothing; # Day 24
        nothing nothing; # Day 25
    ],
    "real" => [
        65912 195625; # Day 01
        10816 11657; # Day 02
        8153 2342; # Day 03
        475 825; # Day 04
        "SVFDLGLWV" "DCVTCVPCL"; # Day 05
        (1531,) (2518,); # Day 06
        1390824 nothing; # Day 07
        nothing nothing; # Day 08
        nothing nothing; # Day 09
        nothing nothing; # Day 10
        nothing nothing; # Day 11
        nothing nothing; # Day 12
        nothing nothing; # Day 13
        nothing nothing; # Day 14
        nothing nothing; # Day 15
        nothing nothing; # Day 16
        nothing nothing; # Day 17
        nothing nothing; # Day 18
        nothing nothing; # Day 19
        nothing nothing; # Day 20
        nothing nothing; # Day 21
        nothing nothing; # Day 22
        nothing nothing; # Day 23
        nothing nothing; # Day 24
        nothing nothing; # Day 25
    ],
)

@testset "Advent of Code 2022" begin
    for day in DAY_RANGE
        for kind in ("example", "real")
            @testset "Day $day, $kind input" begin
                daystr = string(day, base=10, pad=2)
                day_trait = Day{day}()
                input = parse_input(
                    day_trait,
                    read("$ASSETSDIR/day$(daystr)_$(kind).txt", String)
                )
                if input === nothing
                    break
                end
                for part in (1, 2)
                    part_trait = Part{part}()
                    expected = solutions[kind][day, part]
                    if expected === nothing
                        break
                    end
                    obtained = solve(day_trait, part_trait, input)
                    @test obtained == expected
                end # for
            end # testset
        end # for
    end # for
end # testset
