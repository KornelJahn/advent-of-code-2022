@testset "Day 06" begin
    @testset "Example input" begin
        input = Day06.parse_input.(split("""
            mjqjpqmgbljsphdztnvjfqwrcgsmlb
            bvwbjplbgvbhsrlpgdmjqwftvncz
            nppdvjthqldpwncqszvftbrmjlhg
            nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
            zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
            """
        ))
        @test Day06.solve_part1.(input) == [7, 5, 6, 10, 11]
        @test Day06.solve_part2.(input) == [19, 23, 23, 29, 26]
    end

    @testset "Real input" begin
        input = Day06.parse_input(load_input("day06.txt"))

        @test Day06.solve_part1(input) == 1531
        @test Day06.solve_part2(input) == 2518
    end
end
