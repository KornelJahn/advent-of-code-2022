module Day18

using DelimitedFiles
using DataStructures

function parse_input(raw::AbstractString)
    coords = readdlm(IOBuffer(raw), ',', Int)
    ((xmin, xmax), (ymin, ymax), (zmin, zmax)) = extrema.(eachcol(coords))
    (xmin, ymin, zmin) = (xmin, ymin, zmin) .- 1
    (xmax, ymax, zmax) = (xmax, ymax, zmax) .+ 1
    Ns = (xmax, ymax, zmax) .- (xmin, ymin, zmin) .+ 1
    mask = falses(Ns)
    for (x, y, z) in eachrow(coords)
        mask[1 + x - xmin, 1 + y - ymin, 1 + z - zmin] = true
    end
    return mask
end

Input = AbstractArray{<:Bool, 3}

function solve_part1(mask::Input)
    return surface_area(mask)
end

function solve_part2(mask::Input)
    all_surf_area = surface_area(mask)
    hole_surf_area = surface_area(.!(floodfill(mask, [1, 1, 1])))
    return all_surf_area - hole_surf_area
end

function surface_area(mask::Input)
    return sum(sum(abs.(diff(mask; dims))) for dims in 1:3)
end

function floodfill(mask::Input, start)
    q = Vector{typeof(start)}()
    sizehint!(q, length(mask))
    filled = copy(mask)
    push!(q, start)
    while !isempty(q)
        I = pop!(q)
        if !filled[I...]
            filled[I...] = true
        end
        for J in neighbors(filled, I)
            if !filled[J...]
                push!(q, J)
            end
        end
    end
    return filled
end

function neighbors(mask, I)
    @assert length(I) == ndims(mask)
    d = length(I)
    return Iterators.filter(
        J->checkbounds(Bool, mask, J...),
        (I .+ s .* unit(i, d)) for (i, s) in Iterators.product(1:d, (1, -1))
    )
end

unit(i::T, d::T) where {T<:Integer} = (j == i ? 1 : 0 for j in 1:d)

end # module
