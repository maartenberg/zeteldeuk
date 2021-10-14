{ config, lib, pkgs, ... }:

{
  options = {
    services.screen-locker.i3lockPath = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.i3lock}/bin/i3lock";
      description = "Path to i3lock binary.";
    };
  };

  config = {
    services.screen-locker.enable = true;

    services.screen-locker.lockCmd = let
      # Script adapted from xss-lock's `transfer-sleep-lock-i3lock.sh`
      script = pkgs.writeScript "sleep-lock-i3lock" ''
        #!${pkgs.bash}/bin/bash
        ## CONFIGURATION ##############################################################

        # Options to pass to i3lock
        i3lock_options="--color=008080 --pointer=win"

        # Run before starting the locker
        pre_lock() {
            ${pkgs.dunst}/bin/dunstctl set-paused true
            return
        }

        # Run after the locker exits
        post_lock() {
            ${pkgs.dunst}/bin/dunstctl set-paused false
            return
        }

        ###############################################################################

        pre_lock

        # We set a trap to kill the locker if we get killed, then start the locker and
        # wait for it to exit. The waiting is not that straightforward when the locker
        # forks, so we use this polling only if we have a sleep lock to deal with.
        if [[ -e /dev/fd/$${XSS_SLEEP_LOCK_FD:--1} ]]; then
            kill_i3lock() {
                pkill -xu $EUID "$@" i3lock
            }

            trap kill_i3lock TERM INT

            # we have to make sure the locker does not inherit a copy of the lock fd
            ${config.services.screen-locker.i3lockPath} $i3lock_options {XSS_SLEEP_LOCK_FD}<&-

            # now close our fd (only remaining copy) to indicate we're ready to sleep
            exec {XSS_SLEEP_LOCK_FD}<&-

            while kill_i3lock -0; do
                sleep 0.5
            done
        else
            trap 'kill %%' TERM INT
            ${config.services.screen-locker.i3lockPath} -n $i3lock_options &
            wait
        fi

        post_lock
      '';
    in "${script}";

    services.screen-locker.xss-lock.extraOptions = [ "--transfer-sleep-lock" ];
  };
}
