"""
main module initialization

set up for module execution
"""

from importlib.metadata import (
    PackageNotFoundError,
    version,
)

try:
    __version__ = version("pysay")
except PackageNotFoundError:
    # package is not installed
    pass

from pysay.main import (
    main,
)

__all__ = ["main"]
