using Test
using DelimitedFiles

abstract type PuzzlePartTrait end
struct Part{N} <: PuzzlePartTrait end

AbstractStrategy = AbstractArray{<:AbstractChar, 2}

const ROCK = 1
const PAPER = 2
const SCISSORS = 3
const LOSS = -1
const DRAW = 0
const WIN = 1

"""
Decode the opponent's choice.
"""
function decode_opponent_choice(choice::AbstractChar)
    return Dict('A' => ROCK, 'B' => PAPER, 'C' => SCISSORS)[choice]
end

"""
Decode my choice from the 1st part of the puzzle.
"""
function decode_my_strategy(::Part{1}, choice::AbstractChar)
    return Dict('X' => ROCK, 'Y' => PAPER, 'Z' => SCISSORS)[choice]
end

"""
Decode the desired outcome from the 2nd part of the puzzle.
"""
function decode_my_strategy(::Part{2}, outcome::AbstractChar)
    return Dict('X' => LOSS, 'Y' => DRAW, 'Z' => WIN)[outcome]
end

"""
Construct a matrix representing possible outcomes for me.
"""
function make_outcome_matrix()
    outcomes = zeros(Int, 3, 3)
    outcomes[ROCK, PAPER] = WIN
    outcomes[PAPER, SCISSORS] = WIN
    outcomes[SCISSORS, ROCK] = WIN
    # Fill the missing outcomes by exploiting our choice of LOSS, DRAW, and WIN
    # corresponding to -1, 0, and 1, respectively
    outcomes -= transpose(outcomes)
    return outcomes
end

const OUTCOMES = make_outcome_matrix()

"""
Calculate my points in a round for the 1st part of the puzzle.
"""
function calculate_my_points(
    ::Part{1},
    opponent_choice::Integer,
    my_choice::Integer,
)
    outcome = OUTCOMES[opponent_choice, my_choice]
    return 3 * (1 + outcome) + my_choice
end

"""
Calculate my points in a round for the 2nd part of the puzzle.
"""
function calculate_my_points(
    ::Part{2},
    opponent_choice::Integer,
    outcome::Integer,
)
    my_choice = findfirst(x->x==outcome, OUTCOMES[opponent_choice, :])
    return 3 * (1 + outcome) + my_choice
end

function solve(part::PuzzlePartTrait, encrypted_strategy::AbstractStrategy)
    strategy = similar(encrypted_strategy, Int)
    strategy[:, 1] = decode_opponent_choice.(encrypted_strategy[:, 1])
    strategy[:, 2] = decode_my_strategy.(Ref(part), encrypted_strategy[:, 2])
    points = calculate_my_points.(Ref(part), strategy[:, 1], strategy[:, 2])
    return sum(points)
end

function main()
    for part_idx in (1, 2)
        solution = solve(Part{part_idx}(), readdlm(ARGS[1], Char))
        println("Solution (part $part_idx): $solution")
    end
end

function test()
    input = """
        A Y
        B X
        C Z
        """
    encrypted_strategy = readdlm(IOBuffer(input), Char)
    @test solve(Part{1}(), encrypted_strategy) == 15
    @test solve(Part{2}(), encrypted_strategy) == 12
end

if length(ARGS) > 0
    main()
else
    test()
end
