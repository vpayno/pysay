"""
pysay tool main module
"""

import sys

from rich.traceback import (
    install,
)

from pysay import (
    snake,
)

install()  # setup rich


def main() -> None:
    """
    Runs the cli application code.
    """

    snake.say(" ".join(sys.argv[1:]))


if __name__ == "__main__":  # pragma: no cover
    main()
