let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";
  }) { python = "python39"; };

in mach-nix.mkPythonShell {
  requirements = builtins.readFile ./requirements.txt;
}
