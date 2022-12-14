@testset "Day 14" begin
    @testset "Example input" begin
        input = Day14.parse_input("""
            498,4 -> 498,6 -> 496,6
            503,4 -> 502,4 -> 502,9 -> 494,9
            """
        )

        @test Day14.solve_part1(input) == 24
        @test Day14.solve_part2(input) == 93
    end

    @testset "Real input" begin
        input = Day14.parse_input(load_input("day14.txt"))

        @test Day14.solve_part1(input) == 843
        @test Day14.solve_part2(input) == 27625
    end
end
