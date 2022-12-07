module Day7

export parse_input, solve

using ..Puzzle: Day, Part, PartTrait
import ..Puzzle: parse_input, solve

"""
Return a tree of nested vectors of file sizes.
"""
function parse_input(::Day{7}, raw::AbstractString)
    # Skip empty "" at the head
    commands = split(strip(raw), raw"$ ")[2:end]
    return interpret!(commands)
end

function interpret!(commands::AbstractVector{<:AbstractString})
    nodes = Vector{Any}()
    while !isempty(commands)
        cmd = split(popfirst!(commands))
        if cmd[1] == "cd"
            if cmd[2] == ".."
                break
            else
                push!(nodes, interpret!(commands))
            end
        elseif cmd[1] == "ls"
            append!(
                nodes,
                parse.(Ref(Int), filter(x->(x != "dir"), cmd[2:2:end]))
            )
        else
            error("invalid command")
        end
    end
    return nodes
end

# Rely on nested vectors instead of defining a self-referential type
# Skip defining the input type

function solve(::Day{7}, ::Part{1}, input)
    sizes = collect(iter_dirs_dfs(input))
    return sum(filter(<=(100000), sizes))
end

function solve(::Day{7}, ::Part{2}, input)
    sizes = collect(iter_dirs_dfs(input))
    TOTAL = sizes[end]
    CAPACITY = 70000000
    NEEDED = 30000000
    return minimum(filter(>=(NEEDED + TOTAL - CAPACITY), sizes))
end

iter_dirs_dfs(node) = Channel() do ch
    dirs_dfs_inner!(ch, node)
end

function dirs_dfs_inner!(ch::Channel, node)
    if node isa Integer
        # Do not push outer (leaf) nodes (files)
        return node
    else
        total = sum(dirs_dfs_inner!(ch, child) for child in node)
        # Push, however, inner nodes (subdirectories)
        push!(ch, total)
        return total
    end
end

end # module
