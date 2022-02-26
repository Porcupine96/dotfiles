{ ... }:
pkgs: { bin, package ? pkgs."${bin}" }:
pkgs.callPackage
(inputs:
    let pkg = (package.override inputs);
    in
    pkgs.stdenv.mkDerivation {
    name = "${bin}";
    pname = "${bin}";
    phases = [ "installPhase" ];
    installPhase = ''
        mkdir -p "$out/bin" "$out/share"
        # cp -pRL "${pkg}/share" "$out/"

        for f in '${pkg}'/share/*; do # hello emacs */
        ln -s -t "$out/share/" "$f"
        done

        cat >> "$out/bin/${bin}" << EOF
        #!/usr/bin/env sh
        ${pkgs.nixGLIntel}/bin/nixGLIntel ${pkg}/bin/${bin} "\$@"
        EOF
        chmod u+x  "$out/bin/${bin}"
    '';
    })
{ }
