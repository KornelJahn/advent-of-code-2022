@testset "Day 01" begin
    @testset "Example input" begin
        input = Day01.parse_input("""
            1000
            2000
            3000

            4000

            5000
            6000

            7000
            8000
            9000

            10000
            """
        )

        @test Day01.solve_part1(input) == 24000
        @test Day01.solve_part2(input) == 45000
    end

    @testset "Real input" begin
        input = Day01.parse_input(load_input("day01.txt"))

        @test Day01.solve_part1(input) == 65912
        @test Day01.solve_part2(input) == 195625
    end
end
