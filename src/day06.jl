module Day06

AbstractInput = AbstractString

parse_input(raw::AbstractString) = strip(raw)

solve_part1(input::AbstractInput) = find_start(input, windowsize=4)

solve_part2(input::AbstractInput) = find_start(input, windowsize=14)

function find_start(msg::AbstractString; windowsize::Int)
    for stop in windowsize:length(msg)
        start = stop - windowsize + 1
        if is_unique(msg[start:stop])
            return stop
        end
    end
    return nothing
end

is_unique(x) = length(Set(x)) == length(x)

end # module
