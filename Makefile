KL_FILES := $(wildcard src/*.kl)

PC_FILES = $(addprefix bin/,$(notdir $(KL_FILES:.kl=.pc)))

bin/%.pc: src/%.kl src/includes/*.kl
	ktrans $< $@
	rm *.pc

all: $(PC_FILES)

.PHONY : clean todo deploy test

clean:
	rm bin/*.*

todo:
	grep -i "todo" src/*.*

test:
	@curl -s http://localhost/karel/kunit?filenames=test_kunit,test_strlib

deploy:
	ftp -s:deploy.ftp localhost
