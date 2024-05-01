using Clang.Generators
using Clang.JLLEnvs
using JLLPrefixes
import aws_c_common_jll, aws_c_io_jll, aws_c_compression_jll, aws_c_http_jll, aws_c_cal_jll
using LibAwsCommon
using LibAwsIO
using LibAwsCompression
using LibAwsCal

cd(@__DIR__)

# This is called if the docs generated from the extract_c_comment_style method did not generate any lines.
# We need to generate at least some docs so that cross-references work with Documenter.jl.
function get_docs(node, docs)
    # The macro node types (except for MacroDefault) seem to not generate code, but they will still emit docs and then
    # you end up with docs stacked on top of each other, which is a Julia LoadError.
    if node.type isa Generators.AbstractMacroNodeType && !(node.type isa Generators.MacroDefault)
        return String[]
    end

    # don't generate empty docs because it makes Documenter.jl mad
    if isempty(docs)
        return ["Documentation not found."]
    end

    return docs
end

function should_skip_target(target)
    # aws_c_common_jll does not support i686 windows https://github.com/JuliaPackaging/Yggdrasil/blob/bbab3a916ae5543902b025a4a873cf9ee4a7de68/A/aws_c_common/build_tarballs.jl#L48-L49
    return target == "i686-w64-mingw32"
end

const deps_jlls = [aws_c_common_jll, aws_c_io_jll, aws_c_compression_jll, aws_c_cal_jll]
const deps = [LibAwsCommon, LibAwsIO, LibAwsCompression, LibAwsCal]
const deps_names = sort(collect(Iterators.flatten(names.(deps))))

# clang can emit code for forward declarations of structs defined in our dependencies. we need to skip those, otherwise
# we'll have duplicate struct definitions.
function skip_nodes_in_dependencies!(dag::ExprDAG)
    replace!(get_nodes(dag)) do node
        if insorted(node.id, deps_names)
            return ExprNode(node.id, Generators.Skip(), node.cursor, Expr[], node.adj)
        end
        return node
    end
end

# download toolchains in parallel
Threads.@threads for target in JLLEnvs.JLL_ENV_TRIPLES
    if should_skip_target(target)
        continue
    end
    get_default_args(target) # downloads the toolchain
end

for target in JLLEnvs.JLL_ENV_TRIPLES
    if should_skip_target(target)
        continue
    end
    options = load_options(joinpath(@__DIR__, "generator.toml"))
    options["general"]["output_file_path"] = joinpath(@__DIR__, "..", "lib", "$target.jl")
    options["general"]["callback_documentation"] = get_docs

    args = get_default_args(target)
    for dep in deps_jlls
        inc = JLLEnvs.get_pkg_include_dir(dep, target)
        push!(args, "-isystem$inc")
    end

    header_dirs = []
    inc = JLLEnvs.get_pkg_include_dir(aws_c_http_jll, target)
    push!(args, "-I$inc")
    push!(header_dirs, inc)

    headers = String[]
    for header_dir in header_dirs
        for (root, dirs, files) in walkdir(header_dir)
            for file in files
                if endswith(file, ".h")
                    push!(headers, joinpath(root, file))
                end
            end
        end
    end
    unique!(headers)

    ctx = create_context(headers, args, options)
    build!(ctx, BUILDSTAGE_NO_PRINTING)
    skip_nodes_in_dependencies!(ctx.dag)
    build!(ctx, BUILDSTAGE_PRINTING_ONLY)
end
