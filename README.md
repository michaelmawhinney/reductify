# minify

Minify CSS, Javascript, and SVG code. Losslessly optimize JPG, GIF, and PNG images. Compress the following with Zopfli: *.css, *.js, *.html, *.txt, *.xml, *.ico, *.svg, *.png

The **minify** script helps reduce the size of common website elements:

- code is minified -- without affecting functionality.
- images are optimized -- without reducing quality.
- Zopfli compression -- useful for pre-compressed static content.

## Installation

```
git clone https://github.com/michaelmawhinney/minify.git
cd minify/
chmod +x install.sh
./install.sh
```

## Usage

To _minify_ 1 or more files:

`minify <file1> <file2> <file3> ...`

To _minify_ all files in a directory:

`minify /path/to/directory/*`

To _minify_ all files in the current directory:

`minify *`

### Example Usage

`minify index.html style.css image1.jpg image2.png logo.svg`

This command would create the following files:

- index.html.gz
- style.min.css
- style.min.css.gz
- image1.min.jpg
- image2,min.png
- logo.min.svg
- logo.min.svg.gz
