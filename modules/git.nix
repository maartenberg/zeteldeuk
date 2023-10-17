{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-autofixup
    ];

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      delta.enable = true;
      lfs.enable = true;

      userName = "Maarten van den Berg";

      aliases = {
        # https://www.erikschierboom.com/2020/02/17/cleaning-up-local-git-branches-deleted-on-a-remote/
        prune-gone = ''
          ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
      };

      extraConfig = {
        # Implicitly pass `-n` to all `git grep`s
        grep.linenumber = true;

        # Sane diff style for merge conflicts
        merge.conflictStyle = "diff3";

        rebase = {
          # Use single-letter commands by default
          abbreviateCommands = true;

          # Abort rebase if commit is implicitly dropped, require explicit `d` command
          missingCommitsCheck = "error";

          autosquash = true;
        };

        # Show stashed items in `git status`
        status.showStash = true;

        # --recurse-submodules by default
        submodule.recurse = true;

        blame.coloring = "repeatedLines";
        commit.verbose = true;
        rerere.enabled = true;

        color.advice.hint = "blue";
        color.blame.repeatedLines = "normal dim";
        color.transport.rejected = "red bold";
        color.push.error = "red bold";

        column.ui = "auto";

        stash.showPatch = true;

        pull.rebase = true;

        push.autoSetupRemote = true;
      };
    };
  };
}
