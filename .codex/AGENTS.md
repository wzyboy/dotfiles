## Coding convention

When writing Python:

- use type hints
- use PEP-585 built-in generics (e.g. use `list[str]` instead of `List[str]`)
- don't use `typing.Optional` (e.g. use `str | None` instead of `Optional[str]`)
- don't use `typing.Union` (e.g. use `Type1 | Type2` instead of `Union[Type1, Type2]`
- group functions into a class if necessary, but don't create classes for simple features
- prefer single quotes
