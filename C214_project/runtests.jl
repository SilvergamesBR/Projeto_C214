using Test
include("src/models/pokemon.jl")
include("src/models/professor.jl")

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

@testset "professorFromJson Happy Path" begin

    @testset "should parse valid JSON with standard values" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Silva"
        @test prof.horarioDeAtendimento == "08:00 - 12:00"
        @test prof.periodo == "integral"
        @test prof.sala == "101"
        @test prof.predio == ["1", "2", "3", "4", "6"]
    end

    @testset "should parse valid JSON with extra whitespace" begin
        json_str = """{
            "nomeDoProfessor"    :   "Dr. Souza",
            "horarioDeAtendimento": "13:00 - 15:00",
            "periodo"             : "noturno",
            "sala"                : "202",
            "predio"              : ["2", "4"]
        }"""
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Souza"
        @test prof.horarioDeAtendimento == "13:00 - 15:00"
        @test prof.periodo == "noturno"
        @test prof.sala == "202"
        @test prof.predio == ["2", "4"]
    end

    @testset "should parse valid JSON with keys in a different order" begin
        json_str = """
        {
            "sala": "303",
            "predio": ["3", "4", "5"],
            "periodo": "integral",
            "horarioDeAtendimento": "09:00 - 11:00",
            "nomeDoProfessor": "Dr. Oliveira"
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Oliveira"
        @test prof.horarioDeAtendimento == "09:00 - 11:00"
        @test prof.periodo == "integral"
        @test prof.sala == "303"
        @test prof.predio == ["3", "4", "5"]
    end

    @testset "should parse valid JSON with an empty predio array" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Lima",
            "horarioDeAtendimento": "10:00 - 12:00",
            "periodo": "noturno",
            "sala": "404",
            "predio": []
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Lima"
        @test prof.horarioDeAtendimento == "10:00 - 12:00"
        @test prof.periodo == "noturno"
        @test prof.sala == "404"
        @test prof.predio == []
    end

    @testset "should parse valid JSON with a single element in predio" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Pereira",
            "horarioDeAtendimento": "11:00 - 13:00",
            "periodo": "integral",
            "sala": "505",
            "predio": ["1"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Pereira"
        @test prof.horarioDeAtendimento == "11:00 - 13:00"
        @test prof.periodo == "integral"
        @test prof.sala == "505"
        @test prof.predio == ["1"]
    end

    @testset "should parse valid JSON with special characters in nomeDoProfessor" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Ångström",
            "horarioDeAtendimento": "14:00 - 16:00",
            "periodo": "noturno",
            "sala": "606",
            "predio": ["2", "3"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Ångström"
        @test prof.horarioDeAtendimento == "14:00 - 16:00"
        @test prof.periodo == "noturno"
        @test prof.sala == "606"
        @test prof.predio == ["2", "3"]
    end

    @testset "should parse valid JSON with an alternate sala value" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Costa",
            "horarioDeAtendimento": "15:00 - 17:00",
            "periodo": "integral",
            "sala": "707",
            "predio": ["4"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Costa"
        @test prof.horarioDeAtendimento == "15:00 - 17:00"
        @test prof.periodo == "integral"
        @test prof.sala == "707"
        @test prof.predio == ["4"]
    end

    @testset "should parse valid JSON with noturno period" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Gomes",
            "horarioDeAtendimento": "16:00 - 18:00",
            "periodo": "noturno",
            "sala": "808",
            "predio": ["5", "6"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Gomes"
        @test prof.horarioDeAtendimento == "16:00 - 18:00"
        @test prof.periodo == "noturno"
        @test prof.sala == "808"
        @test prof.predio == ["5", "6"]
    end

    @testset "should parse valid JSON with an extra unmapped key" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Fernandes",
            "horarioDeAtendimento": "17:00 - 19:00",
            "periodo": "integral",
            "sala": "909",
            "predio": ["1", "3"],
            "extraKey": "extraValue"
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Fernandes"
        @test prof.horarioDeAtendimento == "17:00 - 19:00"
        @test prof.periodo == "integral"
        @test prof.sala == "909"
        @test prof.predio == ["1", "3"]
    end

    @testset "should parse valid JSON with a larger predio array" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Almeida",
            "horarioDeAtendimento": "08:00 - 10:00",
            "periodo": "noturno",
            "sala": "1010",
            "predio": ["1", "2", "3", "4", "5", "6", "7"]
        }
        """
        prof = professorFromJson(json_str)
        @test prof.nomeDoProfessor == "Dr. Almeida"
        @test prof.horarioDeAtendimento == "08:00 - 10:00"
        @test prof.periodo == "noturno"
        @test prof.sala == "1010"
        @test prof.predio == ["1", "2", "3", "4", "5", "6", "7"]
    end

end

@testset "professorFromJson Bad Path" begin

    @testset "should throw an exception for invalid JSON syntax" begin
        json_str = "not a json string"
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when nomeDoProfessor is missing" begin
        json_str = """
        {
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when horarioDeAtendimento is missing" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when periodo is missing" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when sala is missing" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when predio is missing" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101"
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when predio is not an array" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101",
            "predio": "not an array"
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when nomeDoProfessor is not a string" begin
        json_str = """
        {
            "nomeDoProfessor": 123,
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when horarioDeAtendimento is null" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": null,
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", "2", "3", "4", "6"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

    @testset "should throw an exception when predio contains non-string elements" begin
        json_str = """
        {
            "nomeDoProfessor": "Dr. Silva",
            "horarioDeAtendimento": "08:00 - 12:00",
            "periodo": "integral",
            "sala": "101",
            "predio": ["1", 2, "3"]
        }
        """
        @test_throws Exception professorFromJson(json_str)
    end

end
