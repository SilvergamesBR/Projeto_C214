using JSON3

@enum PokemonType Normal Dark Fire Water Electric Grass Ice Poison Fairy Steel Dragon Ghost Rock Fighting Bug Ground Flying Psychic

const TYPE_MAPPING = Dict(
    "normal"   => Normal,
    "dark"     => Dark,
    "fire"     => Fire,
    "water"    => Water,
    "electric" => Electric,
    "grass"    => Grass,
    "ice"      => Ice,
    "poison"   => Poison,
    "fairy"    => Fairy,
    "steel"    => Steel,
    "dragon"   => Dragon,
    "ghost"    => Ghost,
    "rock"     => Rock,
    "fighting" => Fighting,
    "bug"      => Bug,
    "ground"   => Ground,
    "flying"   => Flying,
    "psychic"  => Psychic
)

struct Pokemon
    name::String
    types::Vector{PokemonType}
end

JSON3.StructType(::Type{Pokemon}) = JSON3.Struct()


function pokemonFromJson(json_str::String)
    j = JSON3.read(json_str)

    name = j["forms"][1]["name"]

    type_names = [el["type"]["name"] for el in j["types"]]

    types = [TYPE_MAPPING[lowercase(t)] for t in type_names]

    return Pokemon(name, types)
end


function pokemonToJson(p::Pokemon)
    JSON3.write(p)
end

function join_types(types::Vector)
    n = length(types)
    if n == 0
        return "Nenhum"
    elseif n == 1
        return string(types[1])
    elseif n == 2
        return string(types[1]) * " e " * string(types[2])
    else
        return join(string.(types[1:end-1]), ", ") * " e " * string(types[end])
    end
end

function pokemonToString(p::Pokemon)
    types_str = join_types(p.types)
    return "Nome: $(p.name)\nTipos: $(types_str)"
end
