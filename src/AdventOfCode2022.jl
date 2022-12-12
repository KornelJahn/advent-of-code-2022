module AdventOfCode2022

export restrict_test

macro include_import_reexport_solutions()
    function make_ex(i::Integer)
        str = string(i, base=10, pad=2)
        srcpath = joinpath(@__DIR__, "day$str.jl")
        if isfile(srcpath)
            return (
                Expr(:call, :include, srcpath),
                Expr(:using, Expr(:., :., Symbol("Day$str"))),
                Expr(:export, Symbol("Day$str")),
            )
        else
            return nothing
        end
    end

    exs = Iterators.flatten(filter(!isnothing, make_ex.(1:25)))
    return Expr(:toplevel, exs...)
end

@include_import_reexport_solutions

const VARNAME_TESTDAY = "AOC2022_DAY"

function restrict_test(day::Integer=0)
    if day == 0
        delete!(ENV, VARNAME_TESTDAY)
    elseif 1 <= day <= 25
        ENV[VARNAME_TESTDAY] = string(day)
    else
        error("invalid day $day")
    end
    return nothing
end

end # module
