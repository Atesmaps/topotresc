#!/bin/bash

script_path=$(readlink -f "$0")
script_dir=$(dirname "${script_path}")
cd "${script_dir}/../web_server/" || exit

printf "Running Flask app..."
flask run --host=0.0.0.0  # Allow traffic from anywhere
