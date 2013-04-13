#!/bin/sh
BASEDIR=$(dirname $0)
cd $BASEDIR 
cd ../chapters

# convert all .md files in the chapters directory to both .tex and .docx
for i in *.md ; do
  
  # generate Word file
  filename_wd=${i/%???/}.docx
  pandoc $i \
         --from=markdown+tex_math_dollars+tex_math_single_backslash+implicit_figures \
         --to=docx \
         --reference-docx="derivatives/word/style.docx" \
         --bibliography="references.bib" \
         -o derivatives/word/$filename_wd
  
  # generate tex file
  filename_tex=${i/%???/}.tex
  pandoc $i \
         --from=markdown+tex_math_dollars+tex_math_single_backslash+implicit_figures \
         --to=latex \
         --chapters \
         --bibliography="references.bib" \
         --natbib \
         -o derivatives/tex/$filename_tex  
done

cd derivatives/tex/
for i in *.tex ; do
  mv $i .$i
  awk -f .tst.awk .$i > $i
  sed -i '' 's/\(\\\includegraphics{\)\([^}]*\)\(}\)/\\\makebox[\\\textwidth]{\1\2\3}/g' $i
  
  
  #sed -i '' 's/\\\includegraphics{/\\\makebox[\\\textwidth][c]{\\\includegraphics{/g' $i
  #sed -i '' 's/\\\caption{/}\\\caption{/g' $i
  rm .$i
done
cd ..
cd ..

# convert  all .md in frontmatter
cd ../frontmatter
for i in *.md ; do
  # generate tex file
  filename_tex=${i/%???/}.tex
  pandoc -o $filename_tex $i
done

for i in *.tex ; do
  mv $i .$i
  awk -f .tst.awk .$i > $i 
  rm .$i
done

cd ..
xelatex dissertation
bibtex dissertation
xelatex dissertation
xelatex dissertation

# hide the log
mv "dissertation.log" ".logged"

# kill temp files
rm "./frontmatter/thanks.tex"
rm "./frontmatter/abstract.tex"
rm "./frontmatter/dedication.tex"
rm "./frontmatter/personalize.tex"

# delete all the junk files
find . -name "*.log" -exec rm -rf {} \;
find . -name "*.aux" -exec rm -rf {} \;
find . -name "*.toc" -exec rm -rf {} \;
find . -name "*.blg" -exec rm -rf {} \;
find . -name "*.bbl" -exec rm -rf {} \;
find . -name "*.out" -exec rm -rf {} \;
find . -name "*.brf" -exec rm -rf {} \;
find . -name "*.tex-e" -exec rm -rf {} \;
find . -name "*.lof" -exec rm -rf {} \;