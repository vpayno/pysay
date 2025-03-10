"""
Snake Tests
"""

from typing import (
    Any,
    List,
    Union,
)

import pytest
from _pytest.capture import (
    CaptureFixture,
    CaptureResult,
)

# Our Project
from pysay import (
    snake,
)

# [[input, expected], ...]
unit_test_data: List[List[str]] = [
    [
        "hello",
        r"""
     _______
    ( hello )
     -------
    """,
    ],
    [
        "hello world!",
        r"""
     ______________
    ( hello world! )
     --------------
    """,
    ],
]

# [[input, expected], ...]
integration_test_data: List[List[Union[str, List[str]]]] = [
    [
        "Hello World!",
        r"""
     ______________
    ( Hello World! )
     --------------
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
    """.rstrip(),
    ],
]


@pytest.mark.parametrize("message,expected", unit_test_data)
def test_snake_bubble(message: str, expected: List[str]) -> None:
    """Runs the method against all of our test data."""

    result: str = snake.bubble(message)

    assert len(result) == len(expected)  # nosec
    assert result == expected  # nosec


@pytest.mark.parametrize("message,expected", integration_test_data)
def test_snake_say(message: str, expected: List[str], capsys: CaptureFixture) -> None:
    """Runs the class methods against all of our test data."""

    captured_out: List[str]
    expected_out: List[str]

    # discard previous output
    captured: CaptureResult[Any] = capsys.readouterr()
    snake.say(message)
    captured = capsys.readouterr()  # capture new output

    # captured_out = captured.out.split("\n")
    captured_out = [*captured.out]
    # expected_out = [str(number) for number in expected]
    expected_out = [*expected]

    print(f"{captured_out} == {expected_out}")
    assert all(e == o for e, o in zip(captured_out, expected_out))  # nosec
