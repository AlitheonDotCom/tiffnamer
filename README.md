# tiffnamer
Extracts tags from TIFF files and prepends their filenames with tag's value.

## Command Line Arguments

| Argument | Description | Default Value |
| -------- | ----------- | ------------- |
| --image-dir | The directory of images to rename. | './images/' |
| --dry-run | If true, emit commands that would have been run without making any changes. | 'false' |
| --tag-index | The integer value of the tag value to fetch from each image. | 65007 |

## Examples

Perform a dry-run:

```
./tiffnamer.rb --dry-run true
```

Prepend files using the value of tag index 9999:

```
./tiffnamer.rb --tag-index 9999
```

A verbose example of the default behavior:

```
./tiffnamer.rb --image-dir ./images/ --dry-run false --tag-index 65007
```
