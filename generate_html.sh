#/bin/zsh
cp $1 ~/pdf
filename=$(basename "$1")
html_filename="${filename%.*}.html"
renamed_index="resume-$(date +%F).html"
echo $filename
echo $html_filename

# Replace special character with a placeholder
sed -i -e 's/❖/!~!/g' ~/pdf/$filename

docker run \
    -ti \
    --platform linux/amd64 \
    --rm \
    -v ~/pdf:/pdf \
    affinda/pdf2htmlex-api \
    pdf2htmlEX \
    --zoom 1.5 \
    /pdf/$filename \
    $html_filename

# Replace placeholder with special character
sed -i -e 's/!~!/❖/g' ~/pdf/$html_filename

cp ~/pdf/$html_filename .

mv index.html $renamed_index
echo "Moving old file to $renamed_index"

mv ./$html_filename index.html
