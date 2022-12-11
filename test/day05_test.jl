@testset "Day 05" begin
    @testset "Example input" begin
        input = Day05.parse_input("""
                [D]    
            [N] [C]    
            [Z] [M] [P]
             1   2   3 

            move 1 from 2 to 1
            move 3 from 1 to 3
            move 2 from 2 to 1
            move 1 from 1 to 2
            """
        )

        @test Day05.solve_part1(input) == "CMZ"
        @test Day05.solve_part2(input) == "MCD"
    end

    @testset "Real input" begin
        input = Day05.parse_input(load_input("day05.txt"))

        @test Day05.solve_part1(input) == "SVFDLGLWV"
        @test Day05.solve_part2(input) == "DCVTCVPCL"
    end
end
