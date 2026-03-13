{ lib, pkgs, ... }:
let
  convertToPng =
    path: width: height:
    let
      baseName = baseNameOf path;
      baseNameNoExt = builtins.match "^(.*)\\..*$" baseName;

      name = if baseNameNoExt == null then baseName else builtins.elemAt baseNameNoExt 0;
    in
    pkgs.runCommand "${name}-${toString width}x${toString height}.png"
      {
        nativeBuildInputs = [ pkgs.librsvg ];
      }
      ''
        rsvg-convert -w ${toString width} -h ${toString height} ${path} -o $out
      '';
in
{
  options.assets = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = "Static or generated asset paths.";
  };

  config.assets = {
    illuminate-logo-svg = ./graphics/illuminate.svg;
    illuminate-logo-128 = convertToPng ./graphics/illuminate.svg 128 128;
    illuminate-logo-512 = convertToPng ./graphics/illuminate.svg 512 512;

    forgejo-theme = ./forgejo/avali-network.css;
    forgejo-home = ./forgejo/home.tmpl;
  };
}
