"""
Batch convert all Grade 5 EngageNY DOCX files to HTML using Aspose.Words.

Extracts DOCXs from ZIPs, converts each to HTML with embedded images,
preserving the directory structure (module/topic/lesson).
"""

import aspose.words as aw
import os
import zipfile
import tempfile
import shutil
import time
import sys

GRADE_DIR = "../../resources/engageny/grade-5"
OUTPUT_DIR = "grade-5-output"
LICENSE_PATH = "Aspose.Words.lic"

# Apply license
if os.path.exists(LICENSE_PATH):
    license = aw.License()
    license.set_license(LICENSE_PATH)
    print("License applied")
else:
    print("WARNING: No license — output will have watermarks")
    sys.exit(1)

# Stats
total_files = 0
total_converted = 0
total_errors = 0
total_html_bytes = 0
start_time = time.time()

# Process each ZIP
for zip_name in sorted(os.listdir(GRADE_DIR)):
    if not zip_name.endswith('.zip'):
        continue

    zip_path = os.path.join(GRADE_DIR, zip_name)
    module_name = zip_name.replace('.zip', '')
    print(f"\n{'='*60}")
    print(f"Processing: {module_name}")
    print(f"{'='*60}")

    # Create output directory for this module
    module_output = os.path.join(OUTPUT_DIR, module_name)
    os.makedirs(module_output, exist_ok=True)

    # Extract to temp dir and process
    with tempfile.TemporaryDirectory() as tmp_dir:
        with zipfile.ZipFile(zip_path, 'r') as zf:
            zf.extractall(tmp_dir)

        # Find all DOCX files
        docx_files = []
        for root, dirs, files in os.walk(tmp_dir):
            for f in sorted(files):
                if f.endswith('.docx') and not f.startswith('~'):
                    docx_files.append(os.path.join(root, f))

        print(f"Found {len(docx_files)} DOCX files")

        for docx_path in docx_files:
            total_files += 1
            filename = os.path.basename(docx_path)
            html_filename = filename.replace('.docx', '.html')

            # Preserve subdirectory structure
            rel_path = os.path.relpath(os.path.dirname(docx_path), tmp_dir)
            output_subdir = os.path.join(module_output, rel_path)
            os.makedirs(output_subdir, exist_ok=True)
            output_path = os.path.join(output_subdir, html_filename)

            try:
                doc = aw.Document(docx_path)

                html_options = aw.saving.HtmlSaveOptions()
                html_options.export_images_as_base64 = True
                html_options.css_style_sheet_type = aw.saving.CssStyleSheetType.EMBEDDED
                html_options.pretty_format = True
                html_options.export_page_setup = True

                doc.save(output_path, html_options)

                size = os.path.getsize(output_path)
                total_html_bytes += size
                total_converted += 1

                # Progress indicator
                size_kb = size / 1024
                print(f"  ✓ {filename} → {size_kb:.0f} KB")

            except Exception as e:
                total_errors += 1
                print(f"  ✗ {filename}: {e}")

elapsed = time.time() - start_time
total_html_mb = total_html_bytes / (1024 * 1024)

print(f"\n{'='*60}")
print(f"BATCH CONVERSION COMPLETE")
print(f"{'='*60}")
print(f"Total DOCX files found: {total_files}")
print(f"Successfully converted:  {total_converted}")
print(f"Errors:                  {total_errors}")
print(f"Total HTML output:       {total_html_mb:.1f} MB")
print(f"Time elapsed:            {elapsed:.1f} seconds")
print(f"Avg per file:            {elapsed/max(total_files,1):.2f} seconds")
print(f"Output directory:        {os.path.abspath(OUTPUT_DIR)}")
