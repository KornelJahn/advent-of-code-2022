module Day13

function parse_input(raw::AbstractString)
    strings = split(replace(strip(raw), "\n\n" => "\n"), '\n')
    return convert_string.(strings)
end

struct InnerNode
    children::Vector{Union{InnerNode, Int}}

    InnerNode(children...) = new(collect(Union{InnerNode, Int}, children))
end

Input = AbstractVector{InnerNode}

function solve_part1(packets::Input)
    pairs = Iterators.partition(packets, 2)
    flags = [Bool(is_ordered(pair...)) for pair in pairs]
    return sum(findall(flags))
end

function solve_part2(packets::Input)
    dividers = convert_string.(["[[2]]", "[[6]]"])
    extended = vcat(packets, dividers)
    sorted = sort(extended, lt=is_ordered)
    return prod(findfirst(==(divider), sorted) for divider in dividers)
end

function convert_string(string::AbstractString)
    return eval(Meta.parse(replace(string, "[" => "InnerNode(", "]" => ")")))
end

function is_ordered(left::InnerNode, right::InnerNode)
    lch = left.children
    rch = right.children
    for i in 1:min(length(lch), length(rch))
        result = is_ordered(lch[i], rch[i])
        if !isnothing(result)
            return result
        end
    end
    return length(lch) == length(rch) ? nothing : (
        length(lch) < length(rch) ? true : false
    )
end

function is_ordered(left::InnerNode, right::Integer)
    return is_ordered(left, InnerNode(right))
end

function is_ordered(left::Integer, right::InnerNode)
    return is_ordered(InnerNode(left), right)
end

function is_ordered(left::T, right::T) where {T<:Integer}
    return left == right ? nothing : (left < right)
end

end # module
