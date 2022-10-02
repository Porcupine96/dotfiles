let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";
  }) {
    python = "python310";
    pypiDataRev = "536f7a11d9a8ddd98d75f5c8db9c3090dfe16d8d";
    pypiDataSha256 = "09xq5bi0zahqkvnna8bl8iz1j0kmmqslg8yjy3c6ysrvcz48wima";
  };

in mach-nix.mkPythonShell {
  requirements = builtins.readFile ./requirements.txt;
}
