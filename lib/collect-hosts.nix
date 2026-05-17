{
  lib,
  inputs,
}:

let
  hosts = builtins.filter (n: (builtins.readDir ./../hosts)."${n}" == "directory") (
    builtins.attrNames (builtins.readDir ./../hosts)
  );

  mkHost =
    host:
    import (./../hosts + "/${host}") {
      inherit lib inputs;
    };
in
lib.genAttrs hosts mkHost
