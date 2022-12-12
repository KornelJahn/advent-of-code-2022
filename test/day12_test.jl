@testset "Day 12" begin
    @testset "Example input" begin
        input = Day12.parse_input("""
            Sabqponm
            abcryxxl
            accszExk
            acctuvwj
            abdefghi
            """
        )

        @test Day12.solve_part1(input) == 31
        @test Day12.solve_part2(input) == 29
    end

    @testset "Real input" begin
        input = Day12.parse_input(load_input("day12.txt"))

        @test Day12.solve_part1(input) == 490
        @test Day12.solve_part2(input) == 488
    end
end
