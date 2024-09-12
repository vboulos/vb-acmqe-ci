#!/bin/bash

############ 1- Start ############
# Encode a content of a file to base64 and copy it into a new file in bash 
##################################

# Replace 'your_file.txt' with the actual path to your file
input_file="secret-options.yaml"
output_file="secret-options-encoded.yaml"

# Read the file content
content=$(cat "$input_file")

# Encode the content to base64
base64_content=$(echo "$content" | base64)

# Save the encoded content to a new file
echo "$base64_content" > "$output_file"

echo "Base64 encoded content saved to $output_file"

############ 1- End ############