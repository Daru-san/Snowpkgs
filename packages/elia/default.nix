{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "elia";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "elia";
    rev = "refs/tags/${version}";
    hash = "sha256-2CKArTo/frYLTI8qFWpkMZzpDoLDPttmMy6ZQpBDXkY=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    aiosqlite
    click
    click-default-group
    google-generativeai
    greenlet
    pydantic
    humanize
    litellm
    pyperclip
    sqlmodel
    xdg-base-dirs
    (textual.overrideAttrs {
      src = fetchFromGitHub {
        owner = "Textualize";
        repo = "textual";
        rev = "v0.79.1";
        hash = "sha256-laGhjlsFWcSgDnTjLSJMdfM6BRZTezIzFSsyVUhpr3Q=";
      };
    })
  ];

  pythonImportsCheck = [ "elia_chat" ];

  meta = {
    description = "Snappy, keyboard-centric terminal user interface for interacting with large language models";
    homepage = "https://github.com/darrenburns/elia";
    changelog = "https://github.com/darrenburns/elia/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "elia";
  };
}
