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

## Output

```console
$ ./temperament4fft
-11 semitone	≒ 135/256 (-8 cents)
-10 semitone	≒ 9/16 (+4 cents)
-9 semitone	≒ 75/128 (-25 cents)	≒ 625/1024 (+45 cents)
-8 semitone	≒ 5/8 (-14 cents)	≒ 81/128 (+8 cents)
-7 semitone	≒ 675/1024 (-22 cents)
-6 semitone	≒ 45/64 (-10 cents)	≒ 729/1024 (+12 cents)
-5 semitone	≒ 3/4 (+2 cents)	≒ 375/512 (-39 cents)
-4 semitone	≒ 25/32 (-27 cents)	≒ 405/512 (-6 cents)
-3 semitone	≒ 27/32 (+6 cents)
-2 semitone	≒ 225/256 (-23 cents)
-1 semitone	≒ 15/16 (-12 cents)	≒ 243/256 (+10 cents)
+0 semitone	≒ 1/1 (+0 cents)	≒ 125/128 (-41 cents)
+1 semitone	≒ 135/128 (-8 cents)
+2 semitone	≒ 9/8 (+4 cents)	≒ 1125/1024 (-37 cents)
+3 semitone	≒ 75/64 (-25 cents)	≒ 625/512 (+45 cents)	≒ 1215/1024 (-4 cents)
+4 semitone	≒ 5/4 (-14 cents)	≒ 81/64 (+8 cents)
+5 semitone	≒ 675/512 (-22 cents)
+6 semitone	≒ 45/32 (-10 cents)	≒ 729/512 (+12 cents)
+7 semitone	≒ 3/2 (+2 cents)	≒ 375/256 (-39 cents)
+8 semitone	≒ 25/16 (-27 cents)	≒ 405/256 (-6 cents)
+9 semitone	≒ 27/16 (+6 cents)
+10 semitone	≒ 225/128 (-23 cents)	≒ 1875/1024 (+47 cents)
+11 semitone	≒ 15/8 (-12 cents)	≒ 243/128 (+10 cents)
```

For example, to transpose up by +6 semitones, you can set the FFT window size ratio to 45/32 (with -10 cents deviation) or 729/512 (+12 cents).
If the base FFT size is 2^N, the actual size becomes 2^N × 45/32 = 2^{N-5} × 45 = 2^{N-5} × 3^2 × 5, which is still a product of small primes and thus efficient for FFT.

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
