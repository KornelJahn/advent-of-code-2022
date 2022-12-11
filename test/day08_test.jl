@testset "Day 08" begin
    @testset "Example input" begin
        input = Day08.parse_input("""
            30373
            25512
            65332
            33549
            35390
            """
        )

        @test Day08.solve_part1(input) == 21
        @test Day08.solve_part2(input) == 8
    end

    @testset "Real input" begin
        input = Day08.parse_input(load_input("day08.txt"))

        @test Day08.solve_part1(input) == 1700
        @test Day08.solve_part2(input) == 470596
    end
end
