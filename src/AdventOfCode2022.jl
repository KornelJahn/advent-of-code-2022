using Printf: @sprintf

"""
Generate include calls and using statements for available daily solutions.
"""
macro days()
    function make_ex(i::Integer)
        d = @sprintf("%02d", i)
        p = "$(@__DIR__)/day$d.jl"
        if isfile(p)
            return (
                Expr(:call, :include, p),
                Expr(:using, Expr(:., :., Symbol("Day$i"))),
            )
        else
            return nothing
        end
    end

    puzzle_mod_path = "$(@__DIR__)/puzzle.jl"
    exs = Iterators.flatten(filter(!isnothing, make_ex.(1:25)))
    return Expr(:toplevel, Expr(:call, :include, puzzle_mod_path), exs...)
end

@days
