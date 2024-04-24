using LibAwsHTTP
using Documenter

DocMeta.setdocmeta!(LibAwsHTTP, :DocTestSetup, :(using LibAwsHTTP); recursive=true)

makedocs(;
    modules=[LibAwsHTTP],
    repo="https://github.com/JuliaServices/LibAwsHTTP.jl/blob/{commit}{path}#{line}",
    sitename="LibAwsHTTP.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://github.com/JuliaServices/LibAwsHTTP.jl",
        assets=String[],
        size_threshold=2_000_000, # 2 MB, we generate about 1 MB page
        size_threshold_warn=2_000_000,
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/JuliaServices/LibAwsHTTP.jl", devbranch="main")
