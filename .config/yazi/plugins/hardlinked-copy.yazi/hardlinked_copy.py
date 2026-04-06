#!/usr/bin/env python3

import sys
import secrets
import subprocess
from pathlib import Path

MAX_ATTEMPTS = 128


def random_suffix() -> str:
    return secrets.token_hex(4)


def candidate_path(source: Path) -> Path:
    return source.with_name(f'{source.name}.copy-{random_suffix()}')


def build_copy(source: Path) -> Path:
    for _ in range(MAX_ATTEMPTS):
        destination = candidate_path(source)
        if not destination.exists() and not destination.is_symlink():
            run_copy(source, destination)
            return destination

    raise RuntimeError(f'failed to find a unique destination for {source}')


def run_copy(source: Path, destination: Path) -> None:
    try:
        subprocess.run(
            ['cp', '-al', '--', str(source), str(destination)],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        stderr = error.stderr.strip()
        stdout = error.stdout.strip()
        detail = stderr or stdout or f'cp exited with status {error.returncode}'
        raise RuntimeError(detail) from error


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print('usage: hardlinked_copy.py SOURCE', file=sys.stderr)
        return 2

    source = Path(argv[1])
    if not source.exists() and not source.is_symlink():
        print(f'source does not exist: {source}', file=sys.stderr)
        return 1

    try:
        destination = build_copy(source)
    except RuntimeError as error:
        print(str(error), file=sys.stderr)
        return 1

    print(destination)
    return 0


if __name__ == '__main__':
    raise SystemExit(main(sys.argv))
