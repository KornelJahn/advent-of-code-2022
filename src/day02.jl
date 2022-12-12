module Day02

using DelimitedFiles

parse_input(raw::AbstractString) = readdlm(IOBuffer(raw), Char)

Input = AbstractArray{<:AbstractChar, 2}

function solve_part1(moves::Input)
    opponent_moves = decode_opponent_move.(@view moves[:, 1])
    my_moves = decode_my_moves.(@view moves[:, 2])
    return sum(calculate_my_points_part1.(opponent_moves, my_moves))
end

function solve_part2(moves::Input)
    opponent_moves = decode_opponent_move.(@view moves[:, 1])
    my_outcomes = decode_my_outcomes.(@view moves[:, 2])
    return sum(calculate_my_points_part2.(opponent_moves, my_outcomes))
end

const ROCK = 1
const PAPER = 2
const SCISSORS = 3
const LOSS = -1
const DRAW = 0
const WIN = 1

function decode_opponent_move(encoded_move::AbstractChar)
    return Dict('A' => ROCK, 'B' => PAPER, 'C' => SCISSORS)[encoded_move]
end

function decode_my_moves(encoded_move::AbstractChar)
    return Dict('X' => ROCK, 'Y' => PAPER, 'Z' => SCISSORS)[encoded_move]
end

function decode_my_outcomes(encoded_outcome::AbstractChar)
    return Dict('X' => LOSS, 'Y' => DRAW, 'Z' => WIN)[encoded_outcome]
end

function make_my_outcome_matrix()
    outcomes = zeros(Int, 3, 3)
    outcomes[ROCK, PAPER] = WIN
    outcomes[PAPER, SCISSORS] = WIN
    outcomes[SCISSORS, ROCK] = WIN
    # Fill the missing outcomes by exploiting our move of LOSS, DRAW, and WIN
    # corresponding to -1, 0, and 1, respectively
    outcomes -= permutedims(outcomes)
    return outcomes
end

const MY_OUTCOMES = make_my_outcome_matrix()

function calculate_my_points_part1(
    opponent_move::Integer,
    my_move::Integer,
)
    my_outcome = MY_OUTCOMES[opponent_move, my_move]
    return 3 * (1 + my_outcome) + my_move
end

function calculate_my_points_part2(
    opponent_move::Integer,
    my_outcome::Integer,
)
    my_move = findfirst(==(my_outcome), MY_OUTCOMES[opponent_move, :])
    return 3 * (1 + my_outcome) + my_move
end

end # module
