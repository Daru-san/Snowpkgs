inputs:
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
      default = inputs.packages.${pkgs.system}.elia;
      type = package;
      description = ''
        Elia package to use
      '';
    };
    settings = {
      default_model = mkOption {
        default = "gpt-4o";
        type = str;
        example = "gemini-1.5-flash-latest";
        description = ''
          The ID or name of the model that is selected by default on launch
        '';
      };
      system_prompt = mkOption {
        default = "";
        type = str;
        description = ''
          System prompt to start on launch
        '';
      };
      theme = mkOption {
        default = "galaxy";
        example = "alpine";
        type = enum [
          "nebula"
          "cobalt"
          "twilight"
          "hacker"
          "alpine"
          "galaxy"
          "nautilus"
          "monokai"
          "textual"
        ];
        description = ''
          Theme for the app.
        '';
      };
      message_code_theme = mkOption {
        default = "monokai";
        example = "dracula";
        description = ''
          Change the syntax highlighting theme of code in messages.
          Choose from https://pygments.org/styles/
        '';
      };
      models = mkOption {
        type = listOf submodule;
        visible = false;
        default = [ ];
        description = ''
          List of models enabled for the app
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile = {
      "elia/config.toml".source = tomlFormat.generate "config.toml" cfg.settings;
    };
  };
}
