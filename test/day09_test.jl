@testset "Day 09" begin
    @testset "Example input" begin
        input = Day09.parse_input("""
            R 4
            U 4
            L 3
            D 1
            R 4
            D 1
            L 5
            R 2
            """
        )

        @test Day09.solve_part1(input) == 13
        @test Day09.solve_part2(input) == 1

        input = Day09.parse_input("""
            R 5
            U 8
            L 8
            D 3
            R 17
            D 10
            L 25
            U 20
            """
        )

        @test Day09.solve_part2(input) == 36
    end

    @testset "Real input" begin
        input = Day09.parse_input(load_input("day09.txt"))

        @test Day09.solve_part1(input) == 6406
        @test Day09.solve_part2(input) == 2643
    end
end
