{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    enum
    mkIf
    literalExpression
    ;
  inherit (types)
    str
    listOf
    submodule
    package
    ;
  tomlFormat = pkgs.formats.toml { };
  cfg = config.programs.elia;
in
{
  options.programs.elia = {
    enable = mkEnableOption "The elia app";
    package = mkOption {
      type = package;
      description = ''
        Elia package to use
      '';
    };
    settings = {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          default_model = "gemini-main";
          theme = "nautilus";
          models = [
            {
              id = "gemini-main";
              name = "gemini/gemini-1.5-flash-latest";
              display_name = "Gemini Flash";
            }
            {
              id = "gemini-2";
              name = "gemini/gemini-1.5-pro-latest";
              display_name = "Gemini Pro";
            }
          ];
        }
      '';
      description = ''
        Configuration file written to
        {file} `$XDG_CONFIG_HOME/elia/config.toml`

        See <https://github.com/darrenburns/elia?tab=readme-ov-file#configuration>
        for full options list
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile = {
      "elia/config.toml".source = tomlFormat.generate "config.toml" cfg.settings;
    };
  };
}
