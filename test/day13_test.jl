@testset "Day 13" begin
    @testset "Example input" begin
        input = Day13.parse_input("""
            [1,1,3,1,1]
            [1,1,5,1,1]

            [[1],[2,3,4]]
            [[1],4]

            [9]
            [[8,7,6]]

            [[4,4],4,4]
            [[4,4],4,4,4]

            [7,7,7,7]
            [7,7,7]

            []
            [3]

            [[[]]]
            [[]]

            [1,[2,[3,[4,[5,6,7]]]],8,9]
            [1,[2,[3,[4,[5,6,0]]]],8,9]
            """
        )

        @test Day13.solve_part1(input) == 13
        @test Day13.solve_part2(input) == 140
    end

    @testset "Real input" begin
        input = Day13.parse_input(load_input("day13.txt"))

        @test Day13.solve_part1(input) == 4734
        @test Day13.solve_part2(input) == 21836
    end
end
