"""
Send a command to all running Neovim instances via the RPC interface.
This _will_ break if you're not the only user on the system with Neovim sessions.
"""

import sys
import glob
from pathlib import Path
from pynvim import attach


if __name__ == "__main__":
    cmd = " ".join(sys.argv[1:])

    for sock in glob.glob("/tmp/nvim*"):
        fd = Path(sock)
        c = attach("socket", path=str(fd / "0"))
        c.command(cmd)
        c.close()
