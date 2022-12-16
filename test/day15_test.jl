@testset "Day 15" begin
    @testset "Example input" begin
        input = Day15.parse_input("""
            Sensor at x=2, y=18: closest beacon is at x=-2, y=15
            Sensor at x=9, y=16: closest beacon is at x=10, y=16
            Sensor at x=13, y=2: closest beacon is at x=15, y=3
            Sensor at x=12, y=14: closest beacon is at x=10, y=16
            Sensor at x=10, y=20: closest beacon is at x=10, y=16
            Sensor at x=14, y=17: closest beacon is at x=10, y=16
            Sensor at x=8, y=7: closest beacon is at x=2, y=10
            Sensor at x=2, y=0: closest beacon is at x=2, y=10
            Sensor at x=0, y=11: closest beacon is at x=2, y=10
            Sensor at x=20, y=14: closest beacon is at x=25, y=17
            Sensor at x=17, y=20: closest beacon is at x=21, y=22
            Sensor at x=16, y=7: closest beacon is at x=15, y=3
            Sensor at x=14, y=3: closest beacon is at x=15, y=3
            Sensor at x=20, y=1: closest beacon is at x=15, y=3
            """
        )

        @test Day15.solve_part1(input, y=10) == 26
        @test Day15.solve_part2(input, xmax=20, ymax=20) == 56000011
    end

    @testset "Real input" begin
        input = Day15.parse_input(load_input("day15.txt"))

        @test Day15.solve_part1(input, y=2000000) == 4907780
        @test Day15.solve_part2(
            input, xmax=4000000, ymax=4000000
        ) == 13639962836448
    end
end
