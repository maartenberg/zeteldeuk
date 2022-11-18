# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@ansible/ansible-language-server-1.0.2" = {
      name = "_at_ansible_slash_ansible-language-server";
      packageName = "@ansible/ansible-language-server";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-1.0.2.tgz";
        sha512 = "z23uIaj9IAdqiB6xHYNOUSrBXJQwQjywMLhKOoejuC7AECXmqLPjYm4cMgiPG3SjO6nmSIe08nq/Qfhu2Bm5ww==";
      };
    };
    "@flatten-js/interval-tree-1.0.19" = {
      name = "_at_flatten-js_slash_interval-tree";
      packageName = "@flatten-js/interval-tree";
      version = "1.0.19";
      src = fetchurl {
        url = "https://registry.npmjs.org/@flatten-js/interval-tree/-/interval-tree-1.0.19.tgz";
        sha512 = "E+uCpmzAP6EL1L0VDligIg2oUnwbzhSMRXts8Ct7OQ+i+dFEgefExcKnTwGFa+MUZGYAIKHBoUWo/f/lhqc1Ew==";
      };
    };
    "balanced-match-1.0.2" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz";
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
      };
    };
    "brace-expansion-2.0.1" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz";
        sha512 = "XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==";
      };
    };
    "fs.realpath-1.0.0" = {
      name = "fs.realpath";
      packageName = "fs.realpath";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha512 = "OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==";
      };
    };
    "glob-8.0.3" = {
      name = "glob";
      packageName = "glob";
      version = "8.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-8.0.3.tgz";
        sha512 = "ull455NHSHI/Y1FqGaaYFaLGkNMMJbavMrEGFXG/PGrg6y7sutWHUHrz6gy6WEBH6akM1M414dWKCNs+IhKdiQ==";
      };
    };
    "inflight-1.0.6" = {
      name = "inflight";
      packageName = "inflight";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
        sha512 = "k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==";
      };
    };
    "inherits-2.0.4" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    };
    "ini-3.0.1" = {
      name = "ini";
      packageName = "ini";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ini/-/ini-3.0.1.tgz";
        sha512 = "it4HyVAUTKBc6m8e1iXWvXSTdndF7HbdN713+kvLrymxTaU4AUBWrJ4vEooP+V7fexnVD3LKcBshjGGPefSMUQ==";
      };
    };
    "lodash-4.17.21" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.17.21";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz";
        sha512 = "v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==";
      };
    };
    "minimatch-5.1.0" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "5.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-5.1.0.tgz";
        sha512 = "9TPBGGak4nHfGZsPBohm9AWg6NoT7QTCehS3BIJABslyZbzxfV78QM2Y6+i741OPZIafFAaiiEMh5OyIrJPgtg==";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha512 = "lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==";
      };
    };
    "uuid-8.3.2" = {
      name = "uuid";
      packageName = "uuid";
      version = "8.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz";
        sha512 = "+NYs2QeMWy+GWFOEm9xnn6HCDp0l7QBD7ml8zLUmJ+93Q5NF0NocErnwkTkXVFNiX3/fpC6afS8Dhb/gz7R7eg==";
      };
    };
    "vscode-jsonrpc-6.0.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz";
        sha512 = "wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==";
      };
    };
    "vscode-languageserver-7.0.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "7.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz";
        sha512 = "60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==";
      };
    };
    "vscode-languageserver-protocol-3.16.0" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz";
        sha512 = "sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==";
      };
    };
    "vscode-languageserver-textdocument-1.0.7" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.7.tgz";
        sha512 = "bFJH7UQxlXT8kKeyiyu41r22jCZXG8kuuVVA33OEJn1diWOZK5n8zBSPZFHVBOu8kXZ6h0LIRhf5UnCo61J4Hg==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-uri-3.0.6" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.6.tgz";
        sha512 = "fmL7V1eiDBFRRnu+gfRWTzyPpNIHJTc4mWnFkwBUmO9U3KPgJAmTx7oxi2bl/Rh6HLdU7+4C9wlj0k2E4AdKFQ==";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha512 = "l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==";
      };
    };
    "yaml-1.10.2" = {
      name = "yaml";
      packageName = "yaml";
      version = "1.10.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/yaml/-/yaml-1.10.2.tgz";
        sha512 = "r3vXyErRCYJ7wg28yvBY5VSoAF8ZvlcW9/BwUzEtUsjvX/DKs24dIkuwjtuprwJJHsbyUbLApepYTR1BN4uHrg==";
      };
    };
  };
in
{
  "@yaegassy/coc-ansible" = nodeEnv.buildNodePackage {
    name = "_at_yaegassy_slash_coc-ansible";
    packageName = "@yaegassy/coc-ansible";
    version = "0.13.2";
    src = fetchurl {
      url = "https://registry.npmjs.org/@yaegassy/coc-ansible/-/coc-ansible-0.13.2.tgz";
      sha512 = "sCIhJFIxnHbfOC0Q07VHmYpmMs6bCAUuFk9bWQBwYKGoIVXeyrGpH/nNpmQEzYXVXjBx1aCooE3+Z7HWLRphmQ==";
    };
    dependencies = [
      sources."@ansible/ansible-language-server-1.0.2"
      sources."@flatten-js/interval-tree-1.0.19"
      sources."balanced-match-1.0.2"
      sources."brace-expansion-2.0.1"
      sources."fs.realpath-1.0.0"
      sources."glob-8.0.3"
      sources."inflight-1.0.6"
      sources."inherits-2.0.4"
      sources."ini-3.0.1"
      sources."lodash-4.17.21"
      sources."minimatch-5.1.0"
      sources."once-1.4.0"
      sources."uuid-8.3.2"
      sources."vscode-jsonrpc-6.0.0"
      sources."vscode-languageserver-7.0.0"
      sources."vscode-languageserver-protocol-3.16.0"
      sources."vscode-languageserver-textdocument-1.0.7"
      sources."vscode-languageserver-types-3.16.0"
      sources."vscode-uri-3.0.6"
      sources."wrappy-1.0.2"
      sources."yaml-1.10.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "ansible-language-server extension for coc.nvim";
      homepage = "https://github.com/yaegassy/coc-ansible#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
  coc-jedi = nodeEnv.buildNodePackage {
    name = "coc-jedi";
    packageName = "coc-jedi";
    version = "0.33.1";
    src = fetchurl {
      url = "https://registry.npmjs.org/coc-jedi/-/coc-jedi-0.33.1.tgz";
      sha512 = "salbSrY3Y7gabfyJlagLRYl5Bc2QRdu4bIbzBa+kXou6tP/4u5YTUA6t0oPl0Q58oxDUydnEwN6twgO5by+uqg==";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "coc.nvim wrapper for the jedi-language-server for Python";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
