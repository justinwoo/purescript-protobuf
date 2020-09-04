{ pkgs ? import <nixpkgs> { } }:
let
  easy-ps = import
    (pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "1ec689df0adf8e8ada7fcfcb513876307ea34226";
      sha256 = "12hk2zbjkrq2i5fs6xb3x254lnhm9fzkcxph0a7ngxyzfykvf4hi";
    }) {
    inherit pkgs;
  };
in
pkgs.mkShell {
  buildInputs = [
    easy-ps.purs-0_13_8
    easy-ps.spago
    pkgs.nodejs-13_x
    easy-ps.pulp
  ];
  LC_ALL = "C.UTF-8"; # https://github.com/purescript/spago/issues/507
}
