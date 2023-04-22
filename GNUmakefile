%.pdf: %.md GNUmakefile
	pandoc -t pdf -o $@ $< -V geometry:margin=.5in -V linkcolor=blue 

%.html: %.md GNUmakefile
	pandoc -t html -o $@ $< 

%.pdf: %.Rmd
	Rscript -e "rmarkdown::render(\"$<\", \"pdf_document\")"

%.R: %.Rmd
	Rscript -e "knitr::purl(\"$<\", documentation = 0)"
