# KUnit

KUnit is a simple unit testing framework for FANUC's KAREL
programming language. KUnit provides useful assertions and test output
feedback via the web browser.

## Example Output

    KUnit

    ........

    Finished in 0.002 seconds
    4000.0 tests/sec, 9500.0 assertions/sec

    8 tests, 19 assertions, 0 failures

## Usage

1. Download the latest release
2. Copy the `kunit.pc` and `strlib.pc` files to your robot
3. Copy the `kunit.h.kl` to your project's support directory or the
   same directory as your KAREL test file
4. `%INCLUDE kunit.h` in your test KAREL program
5. Use the KUnit assertions as described below
6. Make sure to use `kunit_done` at the end of your test file
7. Translate and deploy your KAREL program to your robot
8. Run the test suite at `http://your.robot/KAREL/kunit?filenames=your_test`

## Output Formatting

The output is unformatted by default. Set `output=html` to get HTML formatting.

    http://your.robot/KAREL/kunit?filenames=your_test&output=html

## Running Multiple Tests

You can run multiple test files in parallel by a comma-separated list
of filenames to the test runner.

    http://your.robot/KAREL/kunit?filenames=test_kunit,test_strlib

## Example

Look at the `src/test_kunit.kl` and `src/test_strlib.kl` files for
real-world examples. (Note: the test_kunit.kl file is a bit hack-ish,
but testing KUnit with KUnit? so meta...)

Here's a simple example of testing a routine that adds two INTEGERs
together:

    PROGRAM test_add_int
    -- %NOLOCKGROUP is required to run KAREL from browser
    %NOLOCKGROUP
    -- %INCLUDE the KUnit routines
    %INCLUDE kunit.h

    -- the ROUTINE under test
    ROUTINE add_int(l : INTEGER; r : INTEGER) : INTEGER
    BEGIN
      RETURN(l + r)
    END add_int

    -- one test
    ROUTINE test_11 : BOOLEAN
    BEGIN
      RETURN(kunit_eq_int(2, add_int(1,1)))
    END test_11

    -- second test
    ROUTINE test_22 : BOOLEAN
    BEGIN
      RETURN(kunit_eq_int(4, add_int(2,2)))
    END test_22

    -- one more test
    ROUTINE test_00 : BOOLEAN
    BEGIN
      RETURN(kunit_eq_int(0, add_int(0,0)))
    END test_00

    BEGIN
      -- do some tests
      kunit_test('1+1=2', test_11)
      kunit_test('2+2=4', test_22)
      kunit_test('0+0=0', test_00)

      -- tell the test runner we are done
      kunit_done
    END test_add_int

Since KAREL doesn't support blocks as arguments to functions or
routines, I've found that it's best to simply create a new routine
that returns a BOOLEAN result for each test since there's typically
some setup, teardown, etc. For these contrived examples you could have
simply used the KUnit assertion as the second argument to `kunit_test`:

    kunit_test('1+1=2', kunit_eq_int(2, add_int(1,1)))

## Assertions

`kunit_assert(b : BOOLEAN)` - Assert something is true

`kunit_eq_int(expected : INTEGER; actual : INTEGER)` - Assert two
INTEGERs are equal

`kunit_eq_r(expected : REAL; actual : REAL)` - Assert two REALs are
equal

`kunit_eq_str(expected : STRING; actual : STRING)` - Assert two
STRINGs are equal

`kunit_eq_pos(expected : XYZWPR; actual : XYZWPR` - Assert two
XYZWPR positions are equal.

`kunit_eq_pip(fname : STRING)` - Assert that the KUnit pipe is equal
to the file located at the provided path (generally for use comparing
STRINGs longer than 254 characters)

`kunit_un_int(actual : INTEGER)` - Assert an INTEGER is UNINIT.

`kunit_un_str(actual : STRING)` - Assert a STRING is UNINIT.

`kunit_un_r(actual : REAL)` - Assert a REAL is uninit.

## Under the Hood

All KUnit really does is provide a simple environment that stores
information about the tests you perform. Tests are just any routine that
returns a `BOOLEAN` value. If `true`, the test passes, otherwise the
test fails. KUnit then prints out some useful information about how many
tests you ran, how many failed, how many assertions you made, etc. If
you use the provided KUnit assertions, you'll also get some helpful
debug information about the test. For example, if you use the
`kunit_eq_str()` routine, you might see something like this if it fails:

    -- test routine:
    test('a eqls a', kunit_eq_str('a','b'))

    -- KUnit output:
    1) Failure:
    a eqls a
    Expected "a" but got "b"

## Development

You must have ROBOGUIDE installed and the the WinOLPC bin directory
needs to be on your system $PATH.

1. Download [GnuWin](http://gnuwin32.sourceforge.net) if you don't
   already have it
2. Clone the repository
3. Run `make` to build the KAREL binary PC files
4. Copy the binaries to your ROBOGUIDE or real robot
5. Run the tests from `http://robot.ip/KAREL/test_kunit`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
