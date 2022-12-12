module Day11

mutable struct Monkey
    items::Vector{Int}
    inspect::Function
    divisor::Int
    target_true::Int
    target_false::Int
    counter::Int

    function Monkey(rawstring::AbstractString)
        regex = Regex(replace(raw"""
            Monkey \d+:
              Starting items: (.+)
              Operation: new = (.+)
              Test: divisible by (\d+)
                If true: throw to monkey (\d+)
                If false: throw to monkey (\d+)""",
            '\n' => raw"\n"
        ))

        rawitems, rawop, rawdiv, rawtrue, rawfalse = match(regex, rawstring)
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

parse_input(raw::AbstractString) = map(Monkey, split(strip(raw), "\n\n"))

Input = AbstractVector{Monkey}

function solve_part1(monkeys::Input)
    return calc_business(play_rounds(monkeys, 20, w->div(w, 3)))
end

function solve_part2(monkeys::Input)
    p = prod(monkey.divisor for monkey in monkeys)
    return calc_business(play_rounds(monkeys, 10000, w->mod(w, p)))
end

function play_rounds(
    monkeys::Input,
    round_count::Int,
    relieve::Function,
)
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

test(monkey::Monkey, item::Integer) = mod(item, monkey.divisor) == 0

function calc_business(monkeys::AbstractVector{Monkey})
    return prod(sort(getfield.(monkeys, Ref(:counter)), rev=true)[1:2])
end

end # module
