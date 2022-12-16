module Day15

# TODO: make cleaner by defining interval and rectangle types and operations

function parse_input(raw::AbstractString)
    lines = split(strip(raw), '\n')
    g = raw"(-?\d+)"
    regex = Regex("^Sensor at x=$g, y=$g: closest beacon is at x=$g, y=$g\$")
    iter = (
        tuple(parse.(Ref(Int), m.captures)...)
        for m in match.(Ref(regex), lines)
    )
    return permutedims(reinterpret(reshape, Int, collect(iter)))
end

Input = AbstractArray{Int, 2}

function solve_part1(positions::Input; y::Int)
    (xs, ys, xb, yb) = eachcol(positions)
    r = distance_2d.(xs, ys, xb, yb)
    dy = abs.(ys .- y)
    mask = dy .<= r
    xs = xs[mask]
    ry = r[mask] - dy[mask]
    intervals = union(make_interval.(xs, ry))
    xb = unique(xb[yb .== y])
    beacon_count = sum(any(contains.(intervals, Ref(x))) for x in xb)
    return sum(length_interval.(intervals)) - beacon_count
end

function solve_part2(positions::Input; xmax::Int, ymax::Int)
    (xs, ys, xb, yb) = eachcol(positions)
    radii = distance_2d.(xs, ys, xb, yb)
    @assert all(0 .<= xs .<= xmax)
    @assert all(0 .<= ys .<= ymax)
    # Search for the distress beacon in transformed plane: rotated by 45-deg
    # about the origin and enlarged by a factor of sqrt(2):
    xsp = xs - ys
    ysp = xs + ys

    squares = [
        ((x - r, x + r), (y - r, y + r)) for (x, y, r) in zip(xsp, ysp, radii)
    ]
    initial_rect = ((0, 2*xmax), (0, 2*ymax))

    remainders = rect_remainders(initial_rect, squares)

    # Filter rect with a single element only; that will contain the distress
    # beacon coordinates in the transformed plane
    remainders = filter(A->rect_area(A) == 1, remainders)

    @assert length(remainders) == 1
    ((x0p, _), (y0p, _)) = remainders[1]

    # Transform back the distress beacon coordinates into the coordinate system
    x0 = div(x0p + y0p, 2)
    y0 = div(-x0p + y0p, 2)

    return tuning_frequency(x0, y0)
end

function distance_2d(x1::T, y1::T, x2::T, y2::T) where {T<:Integer}
    return abs(x1 - x2) + abs(y1 - y2)
end

AbstractInterval = Tuple{<:Integer, <:Integer}
AbstractIntervals = AbstractVector{<:AbstractInterval}

function make_interval(xs::T, r::T) where {T<:Integer}
    return (xs - r, xs + r)
end

function length_interval(I::AbstractInterval)
    (a, b) = I
    @assert b >= a
    return b - a + 1
end

function union(intervals::AbstractIntervals)
    sorted = sort(intervals)
    union = [sorted[1]]
    for I in sorted[2:end]
        if are_overlapping(I, union[end])
            union[end] = bounds(I, union[end])
        else
            push!(union, I)
        end
    end
    return union
end

function are_overlapping(I::AbstractInterval, J::AbstractInterval)
    (a, b) = I
    (c, d) = J
    @assert b >= a
    @assert d >= c
    return max(a, c) <= min(b, d)
end

function bounds(I::AbstractInterval, J::AbstractInterval)
    (a, b) = I
    (c, d) = J
    @assert b >= a
    @assert d >= c
    return (min(a, c), max(b, d))
end

function contains(I::AbstractInterval, x::Integer)
    (a, b) = I
    @assert b >= a
    return a <= x <= b
end

function contains(I::AbstractInterval, J::AbstractInterval)
    (a, b) = I
    (c, d) = J
    @assert b >= a
    @assert d >= c
    return a <= c && d <= b
end

AbstractRect = Tuple{<:AbstractInterval, <:AbstractInterval}
AbstractRects = AbstractVector{<:AbstractRect}

function rect_remainders(initial_rect::AbstractRect, rects::AbstractRects)
    As = [initial_rect]
    for B in rects
        Cs = Vector{typeof(initial_rect)}()
        for A in As
            append!(Cs, rect_minus(A, B))
        end
        As = Cs
    end
    return As
end

# Inspired by:
# https://pryp.in/blog/15/intersection-and-difference-of-two-rectangles.html
function rect_intersect(A::AbstractRect, B::AbstractRect)
    (Ax, Ay) = A
    (Bx, By) = B
    x1 = max(Ax[1], Bx[1])
    y1 = max(Ay[1], By[1])
    x2 = min(Ax[2], Bx[2])
    y2 = min(Ay[2], By[2])
    if x1 <= x2 && y1 <= y2
        return ((x1, x2), (y1, y2))
    else
        return nothing
    end
end

# Inspired by:
# https://pryp.in/blog/15/intersection-and-difference-of-two-rectangles.html
function rect_minus(A::AbstractRect, B::AbstractRect)
    (Ax, Ay) = A
    (Bx, By) = B
    intersection = rect_intersect(A, B)
    if isnothing(intersection)
        return [A]
    end
    xs = collect(Ax)
    ys = collect(Ay)
    if Ax[1] < Bx[1] < Ax[2]; push!(xs, Bx[1] - 1); push!(xs, Bx[1]); end
    if Ax[1] < Bx[2] < Ax[2]; push!(xs, Bx[2]); push!(xs, Bx[2] + 1); end
    if Ay[1] < By[1] < Ay[2]; push!(ys, By[1] - 1); push!(ys, By[1]); end
    if Ay[1] < By[2] < Ay[2]; push!(ys, By[2]); push!(ys, By[2] + 1); end
    result = []
    for ((x1, x2), (y1, y2)) in Iterators.product(
        Iterators.partition(sort(xs), 2),
        Iterators.partition(sort(ys), 2)
    )
        rect = ((x1, x2), (y1, y2))
        if rect != intersection
            push!(result, rect)
        end
    end
    return result
end

rect_area(A::AbstractRect) = prod(length_interval.(A))

tuning_frequency(x, y) = 4000000x + y

end # module
