module Day13

function parse_input(raw::AbstractString, convert_string::Function)
    strings = split(replace(strip(raw), "\n\n" => "\n"), '\n')
    return convert_string.(strings)
end

function solve_part1(packets, lessthan::Function)
    pairs = Iterators.partition(packets, 2)
    flags = [lessthan(pair...) for pair in pairs]
    return sum(findall(flags))
end

function solve_part2(packets, convert_string::Function, lessthan::Function)
    dividers = convert_string.(["[[2]]", "[[6]]"])
    extended = vcat(packets, dividers)
    sorted = sort(extended, lt=lessthan)
    return prod(findfirst(==(divider), sorted) for divider in dividers)
end

const OPEN = -1
const CLOSE = -2

function convert_string(string::AbstractString)
    preprocessed = string |>
        strip |>
        s->replace(s, "[" => "$OPEN ", "]" => " $CLOSE", "," => " ") |>
        split
    return parse.(Int, preprocessed)
end

function lessthan(left::T, right::T) where {T<:AbstractVector{<:Integer}}
    ldq = reverse(left)
    rdq = reverse(right)
    while !isempty(ldq) && !isempty(rdq)
        # Pop next symbol from each packet
        l = pop!(ldq)
        r = pop!(rdq)

        if l == r
            continue
        elseif l == OPEN && r != OPEN
            if r == CLOSE
                # Exhaustion case, equivalent to: [[]] > []
                return false
            end
            # Push l
            push!(ldq, l)
            # Push [r]
            push!(rdq, CLOSE)
            push!(rdq, r)
            push!(rdq, OPEN)
        elseif r == OPEN && l != OPEN
            if l == CLOSE
                # Exhaustion case, equivalent to: [] < [[]]
                return true
            end
            # Push r
            push!(rdq, r)
            # Push [l]
            push!(ldq, CLOSE)
            push!(ldq, l)
            push!(ldq, OPEN)
            continue
        else
            # Include exhaustion by exploiting that ] is represented by the
            # negative number CLOSE
            return l < r
        end
    end
    return false
end

parse_input(raw) = parse_input(raw, convert_string)
solve_part1(packets) = solve_part1(packets, lessthan)
solve_part2(packets) = solve_part2(packets, convert_string, lessthan)

# Alternative (slower) solution: tree with recursion

module Alt

import Base: show

struct InnerNode
    children::Vector{Union{InnerNode, Int}}

    InnerNode(children...) = new(collect(Union{InnerNode, Int}, children))
end

function convert_string(string::AbstractString)
    return eval(Meta.parse(replace(string, "[" => "InnerNode(", "]" => ")")))
end

function lessthan(left::T, right::T) where {T<:Union{InnerNode, <:Integer}}
    return compare(left, right) == -1
end

function compare(left::InnerNode, right::InnerNode)
    lch = left.children
    rch = right.children
    for i in 1:min(length(lch), length(rch))
        result = compare(lch[i], rch[i])
        if result != 0
            return result
        end
    end
    return length(lch) == length(rch) ? 0 : (length(lch) < length(rch) ? -1 : 1)
end

function compare(left::InnerNode, right::Integer)
    return compare(left, InnerNode(right))
end

function compare(left::Integer, right::InnerNode)
    return compare(InnerNode(left), right)
end

function compare(left::T, right::T) where {T<:Integer}
    return left == right ? 0 : (left < right ? -1 : 1)
end

end # module Alt

end # module
