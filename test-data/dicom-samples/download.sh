#!/bin/bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

pydicom_base="https://raw.githubusercontent.com/pydicom/pydicom/0e98c4aeecce7c3ae537e3fbe9133d3fbc005796/src/pydicom/data/test_files"
pydicom_data_base="https://raw.githubusercontent.com/pydicom/pydicom-data/abc42b90985fb6cf385aa4af766d2c9c94a257a4/data_store/data"

download_fixture() {
    local base_url="$1"
    local filename="$2"

    if [[ -f "$filename" ]]; then
        return
    fi

    curl --fail --location --retry 3 --output "$filename" "$base_url/$filename"
}

for filename in \
    CT_small.dcm \
    MR_small.dcm \
    MR_small_RLE.dcm \
    MR_small_jp2klossless.dcm \
    SC_rgb_rle_2frame.dcm; do
    download_fixture "$pydicom_base" "$filename"
done

for filename in US1_J2KI.dcm eCT_Supplemental.dcm; do
    download_fixture "$pydicom_data_base" "$filename"
done

shasum -a 256 -c SHA256SUMS
