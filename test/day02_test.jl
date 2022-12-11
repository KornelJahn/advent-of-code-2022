@testset "Day 02" begin
    @testset "Example input" begin
        input = Day02.parse_input("""
            A Y
            B X
            C Z
            """
        )

        @test Day02.solve_part1(input) == 15
        @test Day02.solve_part2(input) == 12
    end

    @testset "Real input" begin
        input = Day02.parse_input(load_input("day02.txt"))

        @test Day02.solve_part1(input) == 10816
        @test Day02.solve_part2(input) == 11657
    end
end
