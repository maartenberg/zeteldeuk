# Updated version of the Vim Python syntax highlighting.
# https://github.com/vim-python/python-syntax
{ config, pkgs, ... }:

{
  config = {
    programs.neovim.plugins = [{
      plugin = let
        version = "2021-01-23";
        rev = "2cc00ba72929ea5f9456a26782db57fb4cc56a65";
        sha256 = "1w4yd25rnbhsps81agvq0kr3vcbifrlpb7h4z0vcgsx1nvmxy205";

      in pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-python-syntax";
        inherit version;

        src = pkgs.fetchFromGitHub {
          owner = "vim-python";
          repo = "python-syntax";
          inherit rev sha256;
        };
      };
    }];
  };
}
