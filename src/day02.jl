module Day2

export parse_input, solve

using DelimitedFiles
using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a 2D array of characters, each row containing the encrypted choice of
the opponent and me.
"""
parse_input(::Day{2}, raw::AbstractString) = readdlm(IOBuffer(raw), Char)

AbstractInput = AbstractArray{<:AbstractChar, 2}

function solve(::Day{2}, part::PartTrait, input::AbstractInput)
    strategy = similar(input, Int)
    strategy[:, 1] = decode_opponent_choice.(input[:, 1])
    strategy[:, 2] = decode_my_strategy.(Ref(part), input[:, 2])
    points = calculate_my_points.(Ref(part), strategy[:, 1], strategy[:, 2])
    return sum(points)
end

const ROCK = 1
const PAPER = 2
const SCISSORS = 3
const LOSS = -1
const DRAW = 0
const WIN = 1

function decode_opponent_choice(choice::AbstractChar)
    return Dict('A' => ROCK, 'B' => PAPER, 'C' => SCISSORS)[choice]
end

function decode_my_strategy(::Part{1}, choice::AbstractChar)
    return Dict('X' => ROCK, 'Y' => PAPER, 'Z' => SCISSORS)[choice]
end

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

function calculate_my_points(
    ::Part{1},
    opponent_choice::Integer,
    my_choice::Integer,
)
    outcome = OUTCOMES[opponent_choice, my_choice]
    return 3 * (1 + outcome) + my_choice
end

function calculate_my_points(
    ::Part{2},
    opponent_choice::Integer,
    outcome::Integer,
)
    my_choice = findfirst(x->x==outcome, OUTCOMES[opponent_choice, :])
    return 3 * (1 + outcome) + my_choice
end

end # module
