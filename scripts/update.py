#!/usr/bin/env python

import subprocess, os, pathlib


currentPath = pathlib.Path().resolve()
currentDir = os.path.abspath(currentPath)

if not "pkgs".upper() in currentDir.upper():
    print("Please run this script in the `snowpkgs` repository")
    exit(0)


gitRootDir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
gitRootDir = gitRootDir[:-1]

os.chdir(gitRootDir)


class Updaters:
    def update_version(self, pname):
        if pname == "seanime":
            subprocess.run(
                [
                    "nix-update",
                    "-F",
                    pname,
                    "--subpackage",
                    "web",
                    "--subpackage",
                    "server",
                    "--subpackage",
                    "desktop",
                    "--commit",
                    "--format",
                ]
            )
        else:
            subprocess.run(["nix-update", "-F", pname, "--commit", "--format"])

    def update_branch(self, pname):

        subprocess.run(
            [
                "nix-update",
                "-F",
                pname,
                "--commit",
                "--format",
                "--version",
                "branch",
            ]
        )


ud = Updaters()
version_pnames = ["bridge-editor", "poketex", "seanime"]
branch_pnames = [
    "valent",
    "kronkhite",
    "waydroid-script",
    "trashy",
    "android-translation-layer",
    "bionic-translation",
    "art-standalone",
]

for x in version_pnames:
    ud.update_version(x)

for x in branch_pnames:
    ud.update_branch(x)
