"""
pysay tool
"""

import sys

from rich.traceback import install

import pysay.snake as snake

install()  # setup rich


def main():
    snake.say(" ".join(sys.argv[1:]))


if __name__ == "__main__":
    main()
