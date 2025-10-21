"""
Тестовый файл для проверки Python настройки в Neovim
"""
from typing import List


def add_numbers(a: int, b: int) -> int:
    """Складывает два числа."""
    return a + b


def process_items(items: List[str]) -> None:
    """Обрабатывает список элементов."""
    for item in items:
        print(f"Processing: {item}")


# Ошибка типа - mypy должен поймать
def broken_function(x: str) -> int:
    return x  # Ошибка: несовпадение типов


# Неиспользованный импорт - ruff должен предупредить
import os  # noqa: F401


# Ошибка стиля - ruff должен исправить
def badly_formatted(    x,y,   z   ):
    return x+y+z


class Person:
    """Класс для демонстрации."""

    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def greet(self) -> str:
        return f"Hello, I'm {self.name}"


if __name__ == "__main__":
    # Нормальный код
    result = add_numbers(5, 10)
    print(f"Result: {result}")

    # Ошибка типа - pyright должен поймать
    wrong_result = add_numbers("hello", "world")  # type: ignore

    person = Person("Alice", 30)
    print(person.greet())
