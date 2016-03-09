bin/%.pc : src/%.kl
	ktrans $< $@ /config config/robot.ini
	cmd //C del *.pc

all: bin/strlib.pc bin/kunit.pc bin/test_kunit.pc bin/test_strlib.pc

clean:
	cmd //C del bin\\\*.pc
