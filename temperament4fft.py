"""
temperament4fft.py

Purpose:
    Find rational approximations r = 2^(-a) * 3^b * 5^c
    for each semitone interval 2^(n/12) in 12-tone equal temperament.
    Useful for choosing FFT sizes composed only of small prime factors.

Run:
    python temperament4fft.py
"""

import math
from fractions import Fraction
from itertools import product


# Primes used for approximation
PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]


def p2r(xs):
    """Given exponent list [e2, e3, e5, ...], return (1/2)^e2 * 3^e3 * 5^e5 * ..."""
    v = Fraction(1)
    for p, x in zip(PRIMES, xs):
        if p == 2:
            v *= Fraction(1, 2) ** x
        else:
            v *= Fraction(p) ** x
    return v


def centsdiff(n, xs):
    """Difference in cents between semitone n and the ratio given by exponent list xs."""
    return (12 * math.log2(float(p2r(xs))) - n) * 100


def lst_ratios(n):
    """Find all rational approximations within 50 cents for semitone n."""
    exponent_range = lambda base: range(0, math.ceil(10 * math.log(2, base)) + 1)
    candidates = product(exponent_range(2), exponent_range(3), exponent_range(5))
    return [
        (p2r(xs), round(centsdiff(n, xs)))
        for xs in candidates
        if abs(centsdiff(n, xs)) < 50
    ]


if __name__ == "__main__":
    for n in range(-11, 12):
        approxs = lst_ratios(n)
        entries = "\t".join(
            f"≒ {r.numerator}/{r.denominator} ({cents:+d} cents)"
            for r, cents in approxs
        )
        print(f"{n:+d} semitone\t{entries}")
