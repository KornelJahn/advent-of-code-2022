module Day16

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    valve_count = length(lines)
    valvedata = parse_line.(lines)
    valveindices = Dict{String, Int}()
    flowrates = Vector{Int}(undef, valve_count)
    for (i, (name, rate, _)) in enumerate(valvedata)
        flowrates[i] = rate
        valveindices[name] = i
    end
    neighbors = Vector{Vector{Int}}(undef, valve_count)
    for (i, (_, _, valve_neighbors)) in enumerate(valvedata)
        neighbors[i] = [valveindices[n] for n in valve_neighbors]
    end
    return flowrates, neighbors
end

Input = Tuple{
    <:AbstractVector{<:Integer},
    <:AbstractVector{<:AbstractVector{<:Integer}}
}

function solve_part1(input::Input)
    (flowrates, neighbors) = input
    new_pressures = collect(visit(input))
    return sum(accumulate(+, new_pressures, init=0))
end

function solve_part2(::Input)
    return nothing
end

function parse_line(line::AbstractString)
    regex = Regex(string(
        raw"^Valve ([A-Z]+) has flow rate=(\d+); ",
        raw"tunnels? leads? to valves? ([A-Z, ]+)$"
    ))
    captures = match(regex, line).captures
    valve_name = captures[1]
    flow_rate = parse(Int, captures[2])
    neighbors = split(captures[3], ", ")
    return valve_name, flow_rate, neighbors
end

visit(input::Input) = Channel{Int}() do ch
    (flowrates, neighbors) = input
    current = 1
    # TODO: preallocate?
    visited = Vector{Int}()
    for t in 1:30
        # TODO: decide algorithm
        put!(ch, flowrates[1])
    end
end

end # module
