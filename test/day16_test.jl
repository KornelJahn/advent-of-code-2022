@testset "Day 16" begin
    @testset "Example input" begin
        input = Day16.parse_input("""
            Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
            Valve BB has flow rate=13; tunnels lead to valves CC, AA
            Valve CC has flow rate=2; tunnels lead to valves DD, BB
            Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
            Valve EE has flow rate=3; tunnels lead to valves FF, DD
            Valve FF has flow rate=0; tunnels lead to valves EE, GG
            Valve GG has flow rate=0; tunnels lead to valves FF, HH
            Valve HH has flow rate=22; tunnel leads to valve GG
            Valve II has flow rate=0; tunnels lead to valves AA, JJ
            Valve JJ has flow rate=21; tunnel leads to valve II
            """
        )

        @test Day16.solve_part1(input) == 1651
        # @test Day16.solve_part2(input) ==
    end

    @testset "Real input" begin
        # input = Day16.parse_input(load_input("day16.txt"))

        # @test Day16.solve_part1(input) ==
        # @test Day16.solve_part2(input) ==
    end
end
