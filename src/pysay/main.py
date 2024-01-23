"""
pysay tool
"""

import sys

from rich.traceback import install

from pysay import snake

install()  # setup rich


def main():
    snake.say(" ".join(sys.argv[1:]))


if __name__ == "__main__":
    main()
