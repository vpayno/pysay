"""
pysay tool main module
"""

import argparse
import sys

from rich.traceback import (
    install,
)

from pysay import (
    __version__,
    snake,
)

_ = install()  # setup rich


def setup() -> None:
    """
    Handles startup setup.
    """
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("-V", "--version", help="show version", action="store_true")

    args = parser.parse_args()

    if args.version:
        print(f"pysay version {__version__}\n")
        sys.exit(0)


def main() -> None:
    """
    Runs the cli application code.
    """
    setup()

    snake.say(" ".join(sys.argv[1:]))


if __name__ == "__main__":  # pragma: no cover
    main()
