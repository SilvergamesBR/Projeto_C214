using Test
include("src/models/pokemon.jl")

@testset "pokemonFromJson tests" begin

    @testset "Valid JSON with single type" begin
        json_str = """
        {
            "forms": [{"name": "pikachu"}],
            "types": [
                {"type": {"name": "electric"}}
            ]
        }
        """
        pokemon = pokemonFromJson(json_str)
        @test pokemon.name == "pikachu"
        @test length(pokemon.types) == 1
        @test pokemon.types[1] == Electric
    end

    @testset "Valid JSON with multiple types" begin
        json_str = """
        {
            "forms": [{"name": "charizard"}],
            "types": [
                {"type": {"name": "fire"}},
                {"type": {"name": "dragon"}}
            ]
        }
        """
        pokemon = pokemonFromJson(json_str)
        @test pokemon.name == "charizard"
        @test length(pokemon.types) == 2
        @test pokemon.types[1] == Fire
        @test pokemon.types[2] == Dragon
    end

    @testset "Case Insensitivity" begin
        json_str = """
        {
            "forms": [{"name": "squirtle"}],
            "types": [
                {"type": {"name": "WATER"}}
            ]
        }
        """
        pokemon = pokemonFromJson(json_str)
        @test pokemon.name == "squirtle"
        @test pokemon.types[1] == Water
    end

    @testset "Empty types array" begin
        json_str = """
        {
            "forms": [{"name": "missingno"}],
            "types": []
        }
        """
        pokemon = pokemonFromJson(json_str)
        @test pokemon.name == "missingno"
        @test length(pokemon.types) == 0
    end

    @testset "Invalid JSON" begin
        json_str = "this is not valid json"
        @test_throws Exception pokemonFromJson(json_str)
    end

end
