@testset "Day 07" begin
    @testset "Example input" begin
        input = Day07.parse_input(raw"""
            $ cd /
            $ ls
            dir a
            14848514 b.txt
            8504156 c.dat
            dir d
            $ cd a
            $ ls
            dir e
            29116 f
            2557 g
            62596 h.lst
            $ cd e
            $ ls
            584 i
            $ cd ..
            $ cd ..
            $ cd d
            $ ls
            4060174 j
            8033020 d.log
            5626152 d.ext
            7214296 k
            """
        )

        @test Day07.solve_part1(input) == 95437
        @test Day07.solve_part2(input) == 24933642
    end

    @testset "Real input" begin
        input = Day07.parse_input(load_input("day07.txt"))

        @test Day07.solve_part1(input) == 1390824
        @test Day07.solve_part2(input) == 7490863
    end
end
