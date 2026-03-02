# temperament4fft

[![CI](https://github.com/tachi-hi/temperament4fft/actions/workflows/ci.yml/badge.svg)](https://github.com/tachi-hi/temperament4fft/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A tool to find rational approximations r = 2^{-a} × 3^b × 5^c of each semitone interval 2^{n/12} in 12-tone equal temperament.

When the FFT size is chosen as 2^N × r, having r composed only of small prime factors enables efficient FFT computation (e.g., [FFTW](http://www.fftw.org/)).
This makes it possible to perform pitch shifting by an arbitrary number of semitones at high speed.

The output of this tool is used in the [Euterpe](https://github.com/tachi-hi/euterpe/) system.

## Requirements

- GHC (Glasgow Haskell Compiler) for the Haskell version
- Python 3 for the Python version

## Build & Run

### Haskell

```sh
ghc -o temperament4fft temperament4fft.hs
./temperament4fft
```

### Python

```sh
python temperament4fft.py
```

## Options

Both versions accept the following command-line arguments:

| Option | Description | Default |
|---|---|---|
| `--primes` | Comma-separated list of primes to use | `2,3,5` |
| `--threshold` | Maximum deviation in cents | `50` |

Example:

```sh
./temperament4fft --primes 2,3,5,7 --threshold 30
python temperament4fft.py --primes 2,3,5,7 --threshold 30
```

## Author

Hideyuki Tachibana (2013)

## License

[MIT](LICENSE)
