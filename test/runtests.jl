using AdventOfCode2022
using AdventOfCode2022: VARNAME_TESTDAY
using Test

load_input(filename::AbstractString) = read(
    joinpath(@__DIR__, "..", "assets", filename), String
)

macro include_tests()
    START = parse(Int, get(ENV, VARNAME_TESTDAY, "1"))
    STOP = parse(Int, get(ENV, VARNAME_TESTDAY, "25"))

    function make_ex(i::Integer)
        str = string(i, base=10, pad=2)
        testpath = joinpath(@__DIR__, "day$(str)_test.jl")
        return Expr(:call, :include, testpath)
    end

    exs = make_ex.(START:STOP)
    return Expr(:toplevel, exs...)
end

@include_tests
