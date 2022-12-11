@testset "Day 11" begin
    @testset "Example input" begin
        input = Day11.parse_input(load_input("day11_example.txt"))

        @test Day11.solve_part1(input) == 10605
        @test Day11.solve_part2(input) == 2713310158
    end

    @testset "Real input" begin
        input = Day11.parse_input(load_input("day11.txt"))

        @test Day11.solve_part1(input) == 117624
        @test Day11.solve_part2(input) == 16792940265
    end
end
