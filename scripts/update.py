#!/usr/bin/env python

import subprocess, os, pathlib


currentPath = pathlib.Path().resolve()
currentDir = os.path.abspath(currentPath)

if not "Snowpkgs".upper() in currentDir.upper():
    print("Please run this script in the `snowpkgs` repository")
    exit(0)


gitRootDir = subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
gitRootDir = gitRootDir[:-1]

os.chdir(gitRootDir)


class Updaters:
    def update_version(self, pname):
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
version_pnames = ["bridge-editor", "poketex"]
branch_pnames = ["valent", "kronkhite", "waydroid-script", "trashy"]

for x in version_pnames:
    ud.update_version(x)

for x in branch_pnames:
    ud.update_branch(x)