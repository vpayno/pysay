"""
Draws the python and speech bubble.
"""

SNAKE = r"""
       \    __
        \  {oo}
           (__)\
             λ \\
               _\\__
              (_____)_
             (________)0o°
"""


def bubble(message):
    r"""
    Draws a speech bubble with the given message.
     _______________
    ( one two three )
     ---------------
    """

    bubble_length = len(message) + 2
    return f"""
    {" " + "_" * bubble_length}
    ( {message} )
    {" " + "-" * bubble_length}
    """


def say(message):
    r"""
    Draws the speech bubble and snake.

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
    """

    print(f"{bubble(message).rstrip()}{SNAKE}")
