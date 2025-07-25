#/bin/zsh
cp $1 ~/pdf
filename=$(basename "$1")
html_filename="${filename%.*}.html"
renamed_index="resume-$(date +%F).html"

echo "Filename: $filename"
echo "HTML Filename: $html_filename"
echo "Renamed Index Filename: $renamed_index"

# Replace special character with a placeholder
# sed -i -e 's/❖/!~!/g' ~/pdf/$filename

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

# Copy the file from the docker container to the host
docker cp $(docker ps -lq):/pdf/$html_filename ~/pdf/$html_filename

# Replace placeholder with special character
# sed -i -e 's/!~!/❖/g' ~/pdf/$html_filename

cp ~/pdf/$html_filename .

if [ -f index.html ]; then
    echo "index.html already exists, renaming it to $renamed_index"
    mv index.html $renamed_index
else
    echo "index.html does not exist, creating a new one"
    
fi

echo "Moving old file to $renamed_index"

mv ./$html_filename index.html
