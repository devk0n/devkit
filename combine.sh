#!/bin/bash

# Output file
output="combined.lua"
> "$output"  # Empty the file if it exists

# Find and sort all .lua files
find . -type f -name "*.lua" | sort | while read -r file; do
    echo "-- >>> BEGIN FILE: $file" >> "$output"
    cat "$file" >> "$output"
    echo -e "\n-- <<< END FILE: $file\n" >> "$output"
done

echo "✅ Combined all .lua files into $output"

