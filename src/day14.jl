module Day14

using OffsetArrays

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    raw_groups = [split.(split(line, " -> "), ",") for line in lines]
    vertex_groups = [[parse.(Ref(Int), v) for v in group] for group in raw_groups]
    (xmin, xmax) = extrema(v[1] for v in Iterators.flatten(vertex_groups))
    (ymin, ymax) = extrema(v[2] for v in Iterators.flatten(vertex_groups))
    (xmin, xmax) = extrema((xmin, xmax, 500))
    (ymin, ymax) = extrema((ymin, ymax, 0))
    occupied = OffsetArray(
        zeros(Bool, ymax - ymin + 1, xmax - xmin + 1),
        ymin:ymax,
        xmin:xmax
    )
    for group in vertex_groups
        for (from, to) in zip(group, group[2:end])
            ((xfrom, yfrom), (xto, yto)) = (from, to)
            (xfrom, xto) = extrema((xfrom, xto))
            (yfrom, yto) = extrema((yfrom, yto))
            occupied[yfrom:yto, xfrom:xto] .= true
        end
    end
    return occupied
end

Input = AbstractArray{Bool, 2}

function solve_part1(occupied::Input)
    return sand_units_to_fill_cave(occupied)
end

function solve_part2(occupied::Input)
    return sand_units_to_fill_cave(enlarge(occupied))
end

function sand_units_to_fill_cave(occupied::Input)
    state = copy(occupied)
    counter = 0
    while advance!(state)
        counter += 1
    end
    return counter
end

function advance!(occupied::Input)
    start = (0, 500)
    (y, x) = start
    if occupied[y, x]
        return false
    end
    while true
        candidates = [(y+1, x), (y+1, x-1), (y+1, x+1)]
        cidx = findfirst(
            p->checkbounds(Bool, occupied, p...) ? !occupied[p...] : true,
            candidates
        )
        if isnothing(cidx)
            occupied[y, x] = true
            return true
        else
            cart = CartesianIndices(occupied)
            try
                (y, x) = Tuple(cart[candidates[cidx]...])
            catch e
                if e isa BoundsError
                    return false
                else
                    rethrow()
                end
            end
        end
    end
end

function enlarge(occupied::Input)
    (ymin, xmin) = first.(axes(occupied))
    (ymax, xmax) = last.(axes(occupied))
    new_ymin = ymin
    new_ymax = ymax + 2
    new_xmin = xmin - ymax
    new_xmax = xmax + ymax
    big_occupied = OffsetArray(
        zeros(Bool, new_ymax - new_ymin + 1, new_xmax - new_xmin + 1),
        new_ymin:new_ymax,
        new_xmin:new_xmax
    )
    big_occupied[end, :] .= true # Floor
    big_occupied[ymin:ymax, xmin:xmax] = occupied
    return big_occupied
end

end # module
