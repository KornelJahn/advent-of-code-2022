@testset "Day 13" begin
    @testset "Example input" begin
        raw = """
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
        input = Day13.parse_input(raw)

        @test Day13.solve_part1(input) == 13
        @test Day13.solve_part2(input) == 140

        # input_alt = Day13.parse_input(raw, Day13.Alt.convert_string)

        # @test Day13.solve_part1(input_alt, Day13.Alt.lessthan) == 13
        # @test Day13.solve_part2(
        #     input_alt, Day13.Alt.convert_string, Day13.Alt.lessthan,
        # ) == 140

    end

    @testset "Real input" begin
        raw = load_input("day13.txt")
        input = Day13.parse_input(raw)

        @test Day13.solve_part1(input) == 4734
        @test Day13.solve_part2(input) == 21836

        # input_alt = Day13.parse_input(raw, Day13.Alt.convert_string)

        # @test Day13.solve_part1(input_alt, Day13.Alt.lessthan) == 4734
        # @test Day13.solve_part2(
        #     input_alt, Day13.Alt.convert_string, Day13.Alt.lessthan
        # ) == 21836
    end
end
