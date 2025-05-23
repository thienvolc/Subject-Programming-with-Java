#!/bin/bash
set -e

MODELS_DIR="../models"
OUTPUT_FILE="database.sql"

# Function to extract dependencies from the first 5 lines of a file
get_dependencies() {
    local file="$1"
    local deps_line
    deps_line=$(head -n 5 "$file" | grep -i "dependencies" | head -n 1 || echo "")
    if [[ "$deps_line" =~ Dependencies:[[:space:]]*(.+)$ ]]; then
        local deps="${BASH_REMATCH[1]}"
        deps=$(echo "$deps" | tr -d '\r\n' | sed 's/,[[:space:]]*/,/g' | tr ',' ' ')
        echo "$deps" | xargs  # trim whitespace
    else
        echo ""
    fi
}

# Step 1: Collect all .sql files and their dependencies
declare -A deps_map
declare -A file_paths
all_files=()

while IFS= read -r -d '' filepath; do
    filename=$(basename "$filepath" .sql)
    file_paths["$filename"]="$filepath"
    all_files+=("$filename")
    deps=$(get_dependencies "$filepath")
    deps_map["$filename"]="$deps"
done < <(find "$MODELS_DIR" -name "*.sql" -type f -print0)

# Step 2: Perform topological sort
declare -A visited
declare -A temp_mark
sorted=()

visit() {
    local node="$1"
    if [[ "${temp_mark[$node]}" == "1" ]]; then
        echo "❌ Circular dependency detected at $node" >&2
        exit 1
    fi
    if [[ "${visited[$node]}" != "1" ]]; then
        temp_mark["$node"]=1
        for dep in ${deps_map[$node]}; do
            if [[ -n "${file_paths[$dep]}" ]]; then
                visit "$dep"
            fi
        done
        temp_mark["$node"]=0
        visited["$node"]=1
        sorted+=("$node")
    fi
}

for file in "${all_files[@]}"; do
    visit "$file"
done

# Step 3: Merge files into a single output file
{
    echo "-- ========================================"
    echo "-- MERGED SQL SCHEMA FILE"
    echo "-- ========================================"
    echo ""
    echo "-- Generated on: $(date)"
    echo "-- Total files: ${#sorted[@]}"
    echo ""
} > "$OUTPUT_FILE"

for filename in "${sorted[@]}"; do
    filepath="${file_paths[$filename]}"
    deps="${deps_map[$filename]}"
    {
        echo ""
        echo "-- ========================================"
        echo "-- FILE: $filename"
        echo "-- Source: $filepath"
        echo "-- Dependencies: $deps"
        echo "-- ========================================"
        echo ""
        # Remove the dependencies line and carriage return characters
        sed 's/\r$//' "$filepath" | grep -v "^--[[:space:]]*Dependencies:"
        echo ""
    } >> "$OUTPUT_FILE"
done

{
    echo "-- ========================================"
    echo "-- END OF MERGED FILE"
    echo "-- ========================================"
} >> "$OUTPUT_FILE"
