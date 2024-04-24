#!/bin/bash
dir=$(dirname "$0")
julia --project="$dir" -e 'using Pkg; Pkg.instantiate()'
julia --project="$dir" -t auto "$dir/generator.jl"
