@testset "Day 04" begin
    @testset "Example input" begin
        input = Day04.parse_input("""
            2-4,6-8
            2-3,4-5
            5-7,7-9
            2-8,3-7
            6-6,4-6
            2-6,4-8
            """
        )

        @test Day04.solve_part1(input) == 2
        @test Day04.solve_part2(input) == 4
    end

    @testset "Real input" begin
        input = Day04.parse_input(load_input("day04.txt"))

        @test Day04.solve_part1(input) == 475
        @test Day04.solve_part2(input) == 825
    end
end
