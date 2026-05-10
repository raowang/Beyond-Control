.PHONY: build clean svg-pdf

XELATEX := /Library/TeX/texbin/xelatex

svg-pdf:
	@python3 .github/scripts/svg2pdf.py

build: svg-pdf
	@mkdir -p latex build release
	@python3 .github/scripts/convert_to_latex.py
	@$(XELATEX) -interaction=nonstopmode -output-directory=./build book.tex
	@$(XELATEX) -interaction=nonstopmode -output-directory=./build book.tex
	@cp build/book.pdf release/重塑组织逻辑.pdf

clean:
	@rm -rf latex build release
	@echo "Cleaned latex/, build/ and release/"