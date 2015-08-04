OUTPUT = idm-qa.pdf idm-qa.html idm-qa.txt

all: ${OUTPUT}

clean:
	rm -f ${OUTPUT}
	
git-ready:
	@${MAKE} -s clean
	@${MAKE} -s all
	@${MAKE} -s clean
	git status	
	
%.pdf: %.md
	pandoc $^ -o $@

%.html: %.md
	pandoc $^ -o $@

%.txt: %.md
	pandoc $^ -o $@
