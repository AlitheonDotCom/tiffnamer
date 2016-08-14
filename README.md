# tiffnamer
Extracts tags from TIFF files and prepends their filenames with tag's value.

## Requirements

You need `Ruby` v2.0.0 or newer and the `LibTIFF` toolchain:
* https://www.ruby-lang.org/en/
* http://www.libtiff.org/tools.html

## Command Line Arguments

| Argument | Description | Default Value |
| -------- | ----------- | ------------- |
| --image-dir | The directory of images to rename. | './images/' |
| --dry-run | If true, emit commands that would have been run without making any changes. | 'false' |
| --tag-index | The tag index (integer value) of the tag value to fetch from each image. | 65007 |
| --undo | Removes the tag prefix from the filename if it exists. | 'false' |

## Examples

Run the script in dry-run mode to preview changes:

```
./tiffnamer.rb --dry-run true
```

Prepend files using the value of tag index 9999:

```
./tiffnamer.rb --tag-index 9999
```

Undo the file rename process:

```
./tiffnamer.rb --undo true
```

A verbose example of the default behavior:

```
./tiffnamer.rb --image-dir ./images/ --dry-run false --tag-index 65007 --undo false
```
