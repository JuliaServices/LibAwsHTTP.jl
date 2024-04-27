using Clang.Generators
using Clang.JLLEnvs
using JLLPrefixes
import aws_c_common_jll, aws_c_io_jll, aws_c_compression_jll, aws_c_http_jll, aws_c_cal_jll

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
    inc = JLLEnvs.get_pkg_include_dir(aws_c_common_jll, target)
    push!(args, "-isystem$inc")
    inc = JLLEnvs.get_pkg_include_dir(aws_c_io_jll, target)
    push!(args, "-isystem$inc")
    inc = JLLEnvs.get_pkg_include_dir(aws_c_compression_jll, target)
    push!(args, "-isystem$inc")
    inc = JLLEnvs.get_pkg_include_dir(aws_c_cal_jll, target)
    push!(args, "-isystem$inc")

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
    build!(ctx)
end
