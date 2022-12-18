@testset "Day 17" begin
    @testset "Example input" begin
        input = Day17.parse_input(">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>")

        @test Day17.solve_part1(input) == 3068
        @test Day17.solve_part2(input) == 1514285714288
    end

    @testset "Real input" begin
        input = Day17.parse_input(load_input("day17.txt"))

        @test Day17.solve_part1(input) == 3085
        @test Day17.solve_part2(input) == 1535483870924
    end
end
