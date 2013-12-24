What's this?
------------

This is a sketch code to calculate a ratio, expressed as r = 2^{-a} * 3^b * 5^c (a, b, c are non-negative integer) that approximates 2^{n/12} (n semitones).
These values are advantageous when considering FFT, because 2^N * r is a product of small primes.
See also the manual of FFTW3 and any documents on Fast Fourier Transform.
The valueds obtained by the code are used in our automatic pitch transposition system, etc.

How to use it
-------------

Modify the code suitably for your purpose.
For example, if you permit the use of more primes such as 7, 11, and 13, you may add them in the code ("candidates").
Then, compile it.

Contributor
-----------

Hideyuki Tachibana 2013

License
-----------
Free


