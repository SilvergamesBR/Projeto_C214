using JSON3

struct Professor
    nomeDoProfessor::String
    horarioDeAtendimento::String
    periodo::String
    sala::String
    predio::Vector{String}
end

JSON3.StructType(::Type{Professor}) = JSON3.Struct()

function professorFromJson(json_str::String)::Professor
    return JSON3.read(json_str, Professor)
end