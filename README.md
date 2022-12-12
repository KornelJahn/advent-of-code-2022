# Advent of Code 2022

Solutions of [Advent of Code 2022](https://adventofcode.com/2022) puzzles, implemented as a [Julia](https://julialang.org/) package.

:warning: Being a Julia beginner, please do not expect elegant, idiomatic, and highly efficient code! :warning:

# Installation

Solutions can be tested using both example and real inputs by first installing the package locally as follows.

While inside the repository directory, start the Julia REPL and switch to the [Pkg package manager](https://docs.julialang.org/en/v1/stdlib/Pkg/) REPL by pressing `]`. Then execute:
```
(@v1.8) pkg> add .
(@v1.8) pkg> activate .
```

# Testing

Still inside the Pkg REPL (while the working in the repo directory), all tests can simply be run as
```
(AdventOfCode2022) pkgs> test
```
which executes [`test/runtests.jl`](test/runtests.jl).

Testing can be restricted to a specific day by calling function `restrict_test()` in the Julia REPL:
```
julia> using AdventOfCode2022
julia> restrict_test(1)
(AdventOfCode2022) pkgs> test
```
The day restriction can be lifted by calling the same function with no arguments:
```
julia> restrict_test()
```
