"""
pysay tool main module
"""

import argparse
import re
import sys
from typing import (
    NoReturn,
    override,
)

from rich.traceback import (
    install,
)

from pysay import (
    __version__,
    snake,
)

_ = install()  # setup rich


class Config:
    version: str = ""
    message: str = ""


type t_config = Config

default_message: str = "Hello World!"


def setup() -> Config:
    """
    Handles startup setup.
    """

    config = Config()

    class ArgumentParserError(Exception):
        pass

    class ThrowingArgumentParser(argparse.ArgumentParser):
        @override
        def error(self, message: str) -> NoReturn:
            raise ArgumentParserError(message)

    parser = ThrowingArgumentParser()
    _ = parser.add_argument("-V", "--version", help="show version", action="store_true")
    _ = parser.add_argument("-m", "--message", help="message to print", type=str, default=default_message)

    try:
        _ = parser.parse_args(namespace=config)
    except ArgumentParserError:
        r = re.compile(r"^(-[a-z]|--[a-z][-a-z0-9]+)$")
        config.message = " ".join([i for i in sys.argv[1:] if not r.match(i)])

    if config.version:
        print(f"pysay version {__version__}\n")
        sys.exit(0)

    match config.message:
        case "-":
            config.message = sys.stdin.read().rstrip()
        case "":
            config.message = "Hmm, try --help"
        case _:
            pass

    return config


def main() -> None:
    """
    Runs the cli application code.
    """
    config: Config = setup()

    snake.say(config.message)


if __name__ == "__main__":  # pragma: no cover
    main()
