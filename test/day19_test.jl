@testset "Day 19" begin
    @testset "Example input" begin
        input = Day19.parse_input("""
            Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
            Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
            """
        )

        @test Day19.solve_part1(input) == 33
        # @test Day19.solve_part2(input) ==
    end

    @testset "Real input" begin
        # input = Day19.parse_input(load_input("day19.txt"))

        # @test Day19.solve_part1(input) ==
        # @test Day19.solve_part2(input) ==
    end
end
