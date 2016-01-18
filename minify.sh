#!/bin/bash
for F in "$@";
do
  EXT=${F##*.}
  EXTENSION=${EXT,,}
  FILENAME=${F%.*}
  if [[ "$EXTENSION" = "css" || "$EXTENSION" = "js" ]] ;
  then
    ## perhaps we can use the google closure compiler here vs yui compressor, need to compare compression results
    /usr/bin/java -jar /minify/yuicompressor-2.4.8.jar "$F" > "$FILENAME.min.$EXTENSION"
    zopfli -i1000 "$FILENAME.min.$EXTENSION"
    touch "$F" "$FILENAME.min.$EXTENSION" "$FILENAME.min.$EXTENSION.gz"
    echo "created $FILENAME.min.$EXTENSION and $FILENAME.min.$EXTENSION.gz"
  elif [[ "$EXTENSION" = "html" || "$EXTENSION" = "txt" || "$EXTENSION" = "xml" || "$EXTENSION" = "ico" ]] ;
  then
    zopfli -i1000 "$F"
    touch "$F" "$F.gz"
    echo "created $F.gz"
  elif [[ "$EXTENSION" = "svg" ]] ;
  then
    svgo -q -i "$F" -o "$FILENAME.min.svg"
    zopfli -i1000 "$FILENAME.min.svg"
    touch "$F" "$FILENAME.min.svg" "$FILENAME.min.svg.gz"
    echo "created $FILENAME.min.svg and $FILENAME.min.svg.gz"
  elif [[ "$EXTENSION" = "jpg" || "$EXTENSION" = "JPG" ]] ;
  then
    jpegtran -copy none -optimize -perfect -outfile "$FILENAME.min.$EXTENSION" "$F"
    touch "$F" "$FILENAME.min.$EXTENSION"
    echo "created $FILENAME.min.$EXTENSION"
  elif [[ "$EXTENSION" = "gif" ]] ;
  then
    gifsicle -O3 "$F" -o "$FILENAME.min.gif" >/dev/null
    touch "$F" "$FILENAME.min.gif"
    echo "created $FILENAME.min.gif"
  elif [[ "$EXTENSION" = "png" ]] ;
  then
    zopflipng --iterations=10 --splitting=3 --filters=01234mepb --lossy_8bit --lossy_transparent -y "$F" "$FILENAME.min.png" >/dev/null
    touch "$F" "$FILENAME.min.png"
    echo "created $FILENAME.min.png"
  else
    :
  fi
done
