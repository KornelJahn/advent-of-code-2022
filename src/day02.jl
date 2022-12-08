module Day2

export parse_input, solve

using DelimitedFiles
using ..Puzzle: Day, Part
import ..Puzzle: parse_input, solve

AbstractInput = AbstractArray{<:AbstractChar, 2}

parse_input(::Day{2}, raw::AbstractString) = readdlm(IOBuffer(raw), Char)

function solve(::Day{2}, part::Part{1}, input::AbstractInput)
    opponent_choices = decode_opponent_choice.(@view input[:, 1])
    my_choices = decode_my_choices.(@view input[:, 2])
    return sum(calculate_my_points.(Ref(part), opponent_choices, my_choices))
end

function solve(::Day{2}, part::Part{2}, input::AbstractInput)
    opponent_choices = decode_opponent_choice.(@view input[:, 1])
    my_outcomes = decode_my_outcomes.(@view input[:, 2])
    return sum(calculate_my_points.(Ref(part), opponent_choices, my_outcomes))
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

function decode_my_choices(choice::AbstractChar)
    return Dict('X' => ROCK, 'Y' => PAPER, 'Z' => SCISSORS)[choice]
end

function decode_my_outcomes(outcome::AbstractChar)
    return Dict('X' => LOSS, 'Y' => DRAW, 'Z' => WIN)[outcome]
end

function make_my_outcome_matrix()
    outcomes = zeros(Int, 3, 3)
    outcomes[ROCK, PAPER] = WIN
    outcomes[PAPER, SCISSORS] = WIN
    outcomes[SCISSORS, ROCK] = WIN
    # Fill the missing outcomes by exploiting our choice of LOSS, DRAW, and WIN
    # corresponding to -1, 0, and 1, respectively
    outcomes -= transpose(outcomes)
    return outcomes
end

const MY_OUTCOMES = make_my_outcome_matrix()

function calculate_my_points(
    ::Part{1},
    opponent_choice::Integer,
    my_choice::Integer,
)
    my_outcome = MY_OUTCOMES[opponent_choice, my_choice]
    return 3 * (1 + my_outcome) + my_choice
end

function calculate_my_points(
    ::Part{2},
    opponent_choice::Integer,
    my_outcome::Integer,
)
    my_choice = findfirst(==(my_outcome), MY_OUTCOMES[opponent_choice, :])
    return 3 * (1 + my_outcome) + my_choice
end

end # module
