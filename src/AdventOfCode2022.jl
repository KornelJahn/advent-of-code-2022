module AdventOfCode2022

export FIRSTDAY, LASTDAY

const FIRSTDAY = 1
const LASTDAY = 11

macro include_import_reexport_solutions()
    function make_ex(i::Integer)
        str = string(i, base=10, pad=2)
        solution_path = joinpath(@__DIR__, "day$str.jl")
        return (
            Expr(:call, :include, solution_path),
            Expr(:using, Expr(:., :., Symbol("Day$str"))),
            Expr(:export, Symbol("Day$str")),
        )
    end

    exs = Iterators.flatten(make_ex.(FIRSTDAY:LASTDAY))
    return Expr(:toplevel, exs...)
end

@include_import_reexport_solutions

end # module
