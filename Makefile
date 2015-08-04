OUTPUT=idm-qa.pdf idm-qa.html

all: ${OUTPUT}

clean:
	rm -f ${OUTPUT}
	
git-ready:
	@${MAKE} clean
	@${MAKE} all
	@${MAKE} clean
	git status	
	
%.pdf: %.md
	pandoc $^ -o $@

%.html: %.md
	pandoc $^ -o $@
