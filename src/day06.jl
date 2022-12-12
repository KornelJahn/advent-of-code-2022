module Day06

Input = AbstractString

parse_input(raw::AbstractString) = strip(raw)

solve_part1(stream::Input) = find_message_marker(stream, windowsize=4)

solve_part2(stream::Input) = find_message_marker(stream, windowsize=14)

function find_message_marker(stream::Input; windowsize::Int)
    for stop in windowsize:length(stream)
        start = stop - windowsize + 1
        if is_unique(stream[start:stop])
            return stop
        end
    end
    return nothing
end

is_unique(x) = length(Set(x)) == length(x)

end # module
