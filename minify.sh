#!/bin/bash

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=zbqvh
LONGOPTIONS=zopfli,bruteforce,quiet,version,help
VERSION=0.2.0
z=n
b=n
q=n

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -z|--zopfli)
            z=y
            shift
            ;;
        -b|--bruteforce)
            b=y
            shift
            ;;
        -q|--quiet)
            q=y
            shift
            ;;
        -v|--version)
            echo "minify v$VERSION"
            exit 0;
            ;;
        -h|--help)
            echo "help menu here"
            exit 0;
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$0: A single input file is required."
    exit 4
fi

# do the work now
for F in "$@";
do
  EXT=${F##*.}
  EXTENSION=${EXT,,}
  FILENAME=${F%.*}
  if [[ "$EXTENSION" = "css" || "$EXTENSION" = "js" ]] ;
  then
    yui-compressor "$F" > "$FILENAME.min.$EXTENSION"
    echo "created $FILENAME.min.$EXTENSION"
    if [ $z = "y" ]
    then
        zopfli -i10 "$FILENAME.min.$EXTENSION"
        touch "$F" "$FILENAME.min.$EXTENSION" "$FILENAME.min.$EXTENSION.gz"
        echo "created $FILENAME.min.$EXTENSION.gz"
    fi
  elif [[ "$EXTENSION" = "html" || "$EXTENSION" = "txt" || "$EXTENSION" = "xml" || "$EXTENSION" = "ico" ]] ;
  then
    if [ $z = "y" ]
    then
        zopfli -i10 "$F"
        touch "$F" "$F.gz"
        echo "created $F.gz"
    fi
  elif [[ "$EXTENSION" = "svg" ]] ;
  then
    svgo -q -i "$F" -o "$FILENAME.min.svg"
    echo "created $FILENAME.min.svg"
    if [ $z = "y" ]
    then
        zopfli -i10 "$FILENAME.min.svg"
        touch "$F" "$FILENAME.min.svg" "$FILENAME.min.svg.gz"
        echo "created $FILENAME.min.svg.gz"
    fi
  elif [[ "$EXTENSION" = "jpg" ]] ;
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
    if [ $b = "y" ]
    then
        pngcrush -brute -reduce "$F" "$FILENAME.min.png"
    else
        pngcrush -rem alla -nofilecheck -reduce -m 7 "$F" "$FILENAME.min.png"
    fi
    touch "$F" "$FILENAME.min.png"
    echo "created $FILENAME.min.png"
  else
    :
  fi
done
