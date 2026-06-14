"""
Test file for verifying the Python setup in Neovim.
"""
from typing import List


def add_numbers(a: int, b: int) -> int:
    """Add two numbers."""
    return a + b


def process_items(items: List[str]) -> None:
    """Process a list of items."""
    for item in items:
        print(f"Processing: {item}")


# Type error - mypy should catch this
def broken_function(x: str) -> int:
    return x  # Error: type mismatch


# Unused import - ruff should warn
import os  # noqa: F401


# Style error - ruff should fix this
def badly_formatted(    x,y,   z   ):
    return x+y+z


class Person:
    """Demonstration class."""

    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def greet(self) -> str:
        return f"Hello, I'm {self.name}"


if __name__ == "__main__":
    # Valid code
    result = add_numbers(5, 10)
    print(f"Result: {result}")

    # Type error - pyright should catch this
    wrong_result = add_numbers("hello", "world")  # type: ignore

    person = Person("Alice", 30)
    print(person.greet())
