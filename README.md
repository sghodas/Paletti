# Paletti
Paletti takes an image and finds its background color as well as the best primary, secondary, and detail text colors that are readable on the background color.

## Usage
Pal just takes one argument: a path to an image file. The path can be local or a remote URL.
```
pal image_path
```
The output will be formatted like this:
```
Background color:
R: 29 G: 31 B: 28

Text colors:
R: 97 G: 131 B: 99
R: 221 G: 242 B: 233
R: 155 G: 188 B: 167
```
The background color is the predominant color of the image at its borders. Paletti prefers non black or white colors, but it will return blacks and whites if they dominate the image.

Text colors are generated using the [W3C recommendations](http://www.w3.org/TR/WCAG20-TECHS/G145.html).

## Author
Satyam Ghodasara, sghodas@gmail.com

## License
Paletti is available under the MIT license. See the LICENSE file for more info.
