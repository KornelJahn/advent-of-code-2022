@testset "Day 18" begin
    @testset "Example input" begin
        input = Day18.parse_input("""
            2,2,2
            1,2,2
            3,2,2
            2,1,2
            2,3,2
            2,2,1
            2,2,3
            2,2,4
            2,2,6
            1,2,5
            3,2,5
            2,1,5
            2,3,5
            """
        )

        @test Day18.solve_part1(input) == 64
        @test Day18.solve_part2(input) == 58
    end

    @testset "Real input" begin
        input = Day18.parse_input(load_input("day18.txt"))

        @test Day18.solve_part1(input) == 4636
        @test Day18.solve_part2(input) == 2572
    end
end
