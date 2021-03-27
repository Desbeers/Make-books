#!/bin/zsh

### Check requirements
if [[ $(whence pandoc) == "" ]]; then
    echo "Pandoc is not installed; aborting." >&2
    exit 1
fi

# For LaTeX, set TEXMFHOME to these scripts:
export TEXMFHOME="$local/texmf"

### Pandoc includes

# Fonts, for ePub and for PDF it should be installed on your system:
export PANDOC_FONTS="$local/fonts"
# Lua filters:
export PANDOC_FILTERS="$local/pandoc/filters"
# Templates
export PANDOC_TEMPLATES="$local/pandoc/templates"
# CSS for ePubs:
export PANDOC_CSS="$local/pandoc/css"
# Default papersize:
export PANDOC_PAPER=$papersize
# Default fontsize:
export PANDOC_FONT=$fontsize

# Only do this when we have metadata. So, not when converting a single page.
# Variable will only be set when it does not exist yet.
if [[ -f $metadata_file ]]; then
    # Get the title.
    : ${title=${$(metadata 'title' $metadata_file)}}
    # Get the author.
    : ${author=${$(metadata 'author' $metadata_file)}}
    # Get the 'collection'.
    : ${collection=${$(metadata 'add-to-collection' $metadata_file)}}    
    # Get the 'collection-position'.
    : ${collection_position=${$(get_collection_position $COLLECTION $collection)}}    
    # Build dir. Replace spaces with dashes.
    : ${BUILD_DIR=$TMPBOOKS/build/$(safe_string $author).$(safe_string $title)}
    # Source dir. Replace spaces with dashes.
    : ${SOURCE_DIR=$TMPBOOKS/source/$(safe_string $author).$(safe_string $title)}
    # Build title.  Replace spaces with dashes.
    : ${BUILD_TITLE=$(safe_string $title)}
    # Export dir:
    : ${EXPORT_DIR=$export/$author/$title}
    # Export title:
    : ${EXPORT_TITLE=$title}
    # Breakup the HTML files in small portions, depending on level.
    # If a book has parts, header is shifted once, if it has books too
    # the header is shifted twice.
    # Only do this for the actual book; not if we are preparing collectons.
    if [[ $PANDOC_ACTION != "Prepair" ]]; then
        if grep -q '{.book}' *.md ; then
            EPUB_CHAPTER_LEVEL=3
        elif grep -q '{.part}' *.md ; then
            EPUB_CHAPTER_LEVEL=2
        else
            EPUB_CHAPTER_LEVEL=1
        fi
    fi
fi

export SOURCE_DIR BUILD_DIR BUILD_TITLE EXPORT_DIR EXPORT_TITLE EPUB_CHAPTER_LEVEL

# Function to reset all 'dynamic' variables:
clear_variables() {
    unset title author collection collection_position SOURCE_DIR BUILD_DIR BUILD_TITLE EXPORT_DIR EXPORT_TITLE
}