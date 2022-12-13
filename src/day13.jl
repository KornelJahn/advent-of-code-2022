module Day13

# FIXME: brute-force, slow, needs optimization

function parse_input(raw::AbstractString)
    strings = split(replace(strip(raw), "\n\n" => "\n"), '\n')
    return eval.(Meta.parse.(strings))
end

function solve_part1(packets)
    pairs = Iterators.partition(packets, 2)
    flags = [Bool(is_ordered(pair...)) for pair in pairs]
    return sum(findall(flags))
end

function solve_part2(packets)
    dividers = [[[2]], [[6]]]
    extended = vcat(packets, dividers)
    sorted = sort(extended, lt=is_ordered)
    return prod(findfirst(==(divider), sorted) for divider in dividers)
end

function is_ordered(left::AbstractVector, right::AbstractVector)
    for i in 1:min(length(left), length(right))
        result = is_ordered(left[i], right[i])
        if !isnothing(result)
            return result
        end
    end
    return length(left) == length(right) ? nothing : (
        length(left) < length(right) ? true : false
    )
end

is_ordered(left::AbstractVector, right::Integer) = is_ordered(left, [right])
is_ordered(left::Integer, right::AbstractVector) = is_ordered([left], right)

function is_ordered(left::T, right::T) where {T<:Integer}
    return left == right ? nothing : (left < right)
end

end # module
