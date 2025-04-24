.PHONY : all latex bibtex view clean arxiv distclean response

TARGET=paper
SOURCE=$(TARGET).tex

DIFF_TARGET=diff
DIFF_SOURCE=$(DIFF_TARGET).tex

ORIGINAL_SOURCE=paper-original-submission-2021-09-09.tex
RESPONSE_SOURCE=response.tex

all:
	pdflatex $(SOURCE)
	bibtex $(TARGET)
	pdflatex $(SOURCE)
	pdflatex $(SOURCE)

response:
	latexdiff $(ORIGINAL_SOURCE) $(SOURCE) > $(DIFF_SOURCE)
	pdflatex $(DIFF_SOURCE)
	bibtex $(DIFF_TARGET)
	pdflatex $(DIFF_SOURCE)
	pdflatex $(DIFF_SOURCE)
	pdflatex $(RESPONSE_SOURCE)
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$(RESPONSE_TARGET)_compressed.pdf $(RESPONSE_TARGET).pdf

compress_pdf:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$(TARGET)_compressed.pdf $(TARGET).pdf

latex:
	pdflatex $(SOURCE)
	pdflatex $(SOURCE)

bibtex:
	bibtex $(TARGET)

view:
	open $(TARGET).pdf &

clean:
	rm -f $(TARGET).aux $(TARGET).bbl $(TARGET).blg $(TARGET).log $(TARGET).out
	rm -f $(DIFF_TARGET).aux $(DIFF_TARGET).bbl $(DIFF_TARGET).blg $(DIFF_TARGET).log $(DIFF_TARGET).out
	rm -f $(RESPONSE_TARGET).aux $(RESPONSE_TARGET).bbl $(RESPONSE_TARGET).blg $(RESPONSE_TARGET).log $(RESPONSE_TARGET).out

distclean:clean
	rm -f $(TARGET).pdf

arxiv:
	arxiv_latex_cleaner $(shell pwd)
