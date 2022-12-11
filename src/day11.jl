module Day11

const MONKEY_REGEX = Regex(replace(raw"""
    Monkey \d+:
      Starting items: (.+)
      Operation: new = (.+)
      Test: divisible by (\d+)
        If true: throw to monkey (\d+)
        If false: throw to monkey (\d+)""",
    '\n' => raw"\n"
))

mutable struct Monkey
    items::Vector{Int}
    inspect::Function
    divisor::Int
    target_true::Int
    target_false::Int
    counter::Int

    function Monkey(rawstring)
        rawitems, rawop, rawdiv, rawtrue, rawfalse = match(
            MONKEY_REGEX, rawstring
        )
        return new(
            parse.(Ref(Int), split(rawitems, ", ")),
            eval(Meta.parse("old->($rawop)")),
            parse(Int, rawdiv),
            parse(Int, rawtrue),
            parse(Int, rawfalse),
            0
        )
    end
end

test(monkey::Monkey, item::Integer) = mod(item, monkey.divisor) == 0

function throw!(
    monkey::Monkey,
    monkeys::AbstractVector{Monkey},
    relieve::Function,
)
    for item in monkey.items
        new_item = relieve(monkey.inspect(item))
        monkey.counter += 1
        if test(monkey, new_item)
            target = monkey.target_true
        else
            target = monkey.target_false
        end
        push!(monkeys[target + 1].items, new_item)
    end
    empty!(monkey.items)
end

AbstractInput = AbstractVector{Monkey}

function parse_input(raw::AbstractString)
    groups = split(strip(raw), "\n\n")
    return map(Monkey, groups)
end

function solve_part1(monkeys::AbstractInput)
    return calculate_level(play_rounds(monkeys, 20, w->div(w, 3)))
end

function solve_part2(monkeys::AbstractInput)
    p = prod(monkey.divisor for monkey in monkeys)
    return calculate_level(play_rounds(monkeys, 10000, w->mod(w, p)))
end

function play_rounds(monkeys::AbstractInput, round_count::Int, relieve::Function)
    @assert round_count >= 1
    monkey_count = length(monkeys)
    result = deepcopy(monkeys)
    for i in 1:round_count
        for j in 1:monkey_count
            throw!(result[j], result, relieve)
        end
    end
    return result
end

function calculate_level(monkeys::AbstractInput)
    return prod(sort(getfield.(monkeys, Ref(:counter)), rev=true)[1:2])
end

end # module
