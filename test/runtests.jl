using Test, Aqua, LibAwsHTTP, LibAwsIO, LibAwsCompression, LibAwsCommon

@testset "LibAwsHTTP" begin
    @testset "aqua" begin
        Aqua.test_all(LibAwsHTTP, ambiguities=false)
        Aqua.test_ambiguities(LibAwsHTTP)
    end
    @testset "basic usage to test the library loads" begin
        alloc = aws_default_allocator() # important! this shouldn't need to be qualified! if we generate a definition for it in LibAwsHTTP that is a bug.
        aws_http_library_init(alloc)
    end
end
