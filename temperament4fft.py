"""
temperament4fft.py

Purpose:
    Find rational approximations r = 2^(-a) * 3^b * 5^c * ...
    for each semitone interval 2^(n/12) in 12-tone equal temperament.
    Useful for choosing FFT sizes composed only of small prime factors.

Run:
    python temperament4fft.py
    python temperament4fft.py --primes 2,3,5,7 --threshold 30
"""

import argparse
import math
from fractions import Fraction
from itertools import product


# Primes used for approximation
ALL_PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]


def p2r(xs):
    """Given exponent list [e2, e3, e5, ...], return (1/2)^e2 * 3^e3 * 5^e5 * ..."""
    v = Fraction(1)
    for p, x in zip(ALL_PRIMES, xs):
        if p == 2:
            v *= Fraction(1, 2) ** x
        else:
            v *= Fraction(p) ** x
    return v


def centsdiff(n, xs):
    """Difference in cents between semitone n and the ratio given by exponent list xs."""
    return (12 * math.log2(float(p2r(xs))) - n) * 100


def lst_ratios(n, primes, threshold):
    """Find all rational approximations within threshold cents for semitone n."""
    exponent_range = lambda base: range(0, math.ceil(10 * math.log(2, base)) + 1)
    candidates = product(*(exponent_range(p) for p in primes))
    return [
        (p2r(xs), round(centsdiff(n, xs)))
        for xs in candidates
        if abs(centsdiff(n, xs)) < threshold
    ]


def parse_args():
    parser = argparse.ArgumentParser(
        description="Find rational approximations for semitone intervals"
    )
    parser.add_argument(
        "--primes", type=str, default="2,3,5",
        help="comma-separated list of primes to use (default: 2,3,5)"
    )
    parser.add_argument(
        "--threshold", type=float, default=50,
        help="maximum deviation in cents (default: 50)"
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    primes = [int(p) for p in args.primes.split(",")]
    threshold = args.threshold

    for n in range(-11, 12):
        approxs = lst_ratios(n, primes, threshold)
        entries = "\t".join(
            f"≒ {r.numerator}/{r.denominator} ({cents:+d} cents)"
            for r, cents in approxs
        )
        print(f"{n:+d} semitone\t{entries}")
