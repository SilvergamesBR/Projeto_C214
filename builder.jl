using Pkg
using TOML
using PackageCompiler

project_toml_path = "C214_project/Project.toml"

project_info = TOML.parsefile(project_toml_path)

version = project_info["version"]

output_dir = "build/$(version)"

# Create the app
create_app("C214_project", output_dir;
           executables = ["GetPokemon" => "main"])
