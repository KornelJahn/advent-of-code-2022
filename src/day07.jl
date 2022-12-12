module Day07

function parse_input(raw::AbstractString)
    # Skip empty string at the head
    commands = split(strip(raw), raw"$ ")[2:end]
    return interpret!(commands)
end

function solve_part1(dir_tree)
    sizes = calc_dirsizes(dir_tree)
    return sum(filter(<=(100000), sizes))
end

function solve_part2(dir_tree)
    sizes = calc_dirsizes(dir_tree)
    TOTAL = sizes[end]
    CAPACITY = 70000000
    NEEDED = 30000000
    return minimum(filter(>=(NEEDED + TOTAL - CAPACITY), sizes))
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
            append!(nodes, parse.(Ref(Int), filter(!=("dir"), cmd[2:2:end])))
        else
            error("invalid command")
        end
    end
    return nodes
end

calc_dirsizes(dir_tree) = collect(iter_dirs_dfs(dir_tree))

# TODO: Switch to an iterative search?

iter_dirs_dfs(node) = Channel() do ch
    dirs_dfs_inner!(ch, node)
end

function dirs_dfs_inner!(ch::Channel, node)
    if node isa Integer
        # Do not put outer (leaf) nodes (files) to the channel
        return node
    else
        total = sum(dirs_dfs_inner!(ch, child) for child in node)
        # Put inner nodes (subdirectories) to the channel
        put!(ch, total)
        return total
    end
end

end # module
