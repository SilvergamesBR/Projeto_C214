module C214_project

using HTTP
using Random

include("models/pokemon.jl")

function main()
    url = "https://pokeapi.co/api/v2/pokemon/$(rand(1:1025))"

    response = HTTP.get(url)

    if response.status == 200

        json_str = String(response.body)

        pokemon_instance = pokemonFromJson(json_str)

        println(pokemonToString(pokemon_instance))
    else
        println("Error: Received status code ", response.status)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end  # module
