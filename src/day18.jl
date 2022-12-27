module Day18

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    coords = Array{Int, 2}(undef, 3, length(lines))
    coords[:] .= Iterators.flatten(
        parse.(Ref(Int), split(line, ',')) for line in lines
    )
    return coords
end

Input = AbstractArray{<:Integer, 2}

function solve_part1(coords::Input)
    return surface_area(coords)
end

function solve_part2(coords::Input)
    return exterior_surface_area(coords)
end

function surface_area(coords::Input)
    area = 0
    for i in 0:2
        indices = mod.([i, i+1, i+2], 3) .+ 1
        sortedcoords = sortslices(coords[indices, :], dims=2)
        cols = eachcol(sortedcoords)
        for (t1, t2) in zip(cols, Iterators.drop(cols, 1))
            if !(t2[1] == t1[1] && t2[2] == t1[2] && t2[3] == t1[3] + 1)
                area += 2
            end
        end
        area += 2
    end
    return area
end

function exterior_surface_area(coords::Input)
    area = 0
    for i in 0:2
        indices = mod.([i, i+1, i+2], 3) .+ 1
        sortedcoords = sortslices(coords[indices, :], dims=2)
        cols = eachcol(sortedcoords)
        for (t1, t2) in zip(cols, Iterators.drop(cols, 1))
            if !(t2[1] == t1[1] && t2[2] == t1[2])
                area += 2
            end
        end
        area += 2
    end
    return area
end

end # module
