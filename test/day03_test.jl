@testset "Day 03" begin
    @testset "Example input" begin
        input = Day03.parse_input("""
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw
            """
        )

        @test Day03.solve_part1(input) == 157
        @test Day03.solve_part2(input) == 70
    end

    @testset "Real input" begin
        input = Day03.parse_input(load_input("day03.txt"))

        @test Day03.solve_part1(input) == 8153
        @test Day03.solve_part2(input) == 2342
    end
end
