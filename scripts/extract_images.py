"""
Extract image positioning metadata from the DOCX XML.
Returns a mapping of rId -> positioning info that can be used
to apply correct CSS to mammoth's HTML output.
"""

import sys, os, zipfile, json
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '.venv', 'lib', 'python3.14', 'site-packages'))
from lxml import etree

DOCX = "Module 2/Math G5-M2 Lessons/Math-G5-M2-Topic-B-Lessons-3-9/math-g5-m2-topic-b-lesson-4.docx"
EMU_PER_INCH = 914400
COLUMN_WIDTH_EMU = 5943600  # ~6.5 inches typical column

def extract_image_positions(docx_path):
    """Parse the DOCX XML to extract image positioning metadata."""
    ns = {
        'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
        'wp': 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
        'a': 'http://schemas.openxmlformats.org/drawingml/2006/main',
        'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
        'pic': 'http://schemas.openxmlformats.org/drawingml/2006/picture',
    }

    with zipfile.ZipFile(docx_path) as z:
        doc_xml = z.read('word/document.xml')
        # Also get the rels to map rId -> image filename
        rels_xml = z.read('word/_rels/document.xml.rels')

    tree = etree.fromstring(doc_xml)
    rels_tree = etree.fromstring(rels_xml)

    # Build rId -> filename mapping
    rid_to_file = {}
    for rel in rels_tree:
        rid = rel.get('Id')
        target = rel.get('Target')
        if target and 'image' in target.lower():
            rid_to_file[rid] = target

    images = []
    drawings = tree.findall('.//w:drawing', ns)

    for i, drawing in enumerate(drawings):
        inline = drawing.find('wp:inline', ns)
        anchor = drawing.find('wp:anchor', ns)

        if inline is not None:
            el = inline
            pos_type = 'inline'
        elif anchor is not None:
            el = anchor
            pos_type = 'anchor'
        else:
            continue

        # Get display size in inches
        extent = el.find('wp:extent', ns)
        if extent is not None:
            w_in = int(extent.get('cx', 0)) / EMU_PER_INCH
            h_in = int(extent.get('cy', 0)) / EMU_PER_INCH
        else:
            w_in = h_in = 0

        # Get image reference
        blip = el.find('.//a:blip', ns)
        r_ns = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
        embed = blip.get(f'{{{r_ns}}}embed') if blip is not None else None
        filename = rid_to_file.get(embed, None) if embed else None

        # Skip non-image drawings (VML shapes, lines, etc.)
        if filename is None:
            continue

        info = {
            'index': i,
            'type': pos_type,
            'rId': embed,
            'filename': filename,
            'width_in': round(w_in, 2),
            'height_in': round(h_in, 2),
        }

        if pos_type == 'anchor':
            # Horizontal position
            posH = el.find('wp:positionH', ns)
            if posH is not None:
                info['relH'] = posH.get('relativeFrom')
                h_offset = posH.find('wp:posOffset', ns)
                h_align = posH.find('wp:align', ns)
                if h_offset is not None:
                    offset_emu = int(h_offset.text)
                    info['h_offset_in'] = round(offset_emu / EMU_PER_INCH, 2)
                    # Determine if right-aligned: offset > 50% of column
                    info['is_right'] = offset_emu > (COLUMN_WIDTH_EMU * 0.45)
                elif h_align is not None:
                    info['h_align'] = h_align.text
                    info['is_right'] = h_align.text in ('right', 'outside')

            # Vertical position
            posV = el.find('wp:positionV', ns)
            if posV is not None:
                info['relV'] = posV.get('relativeFrom')

            # Wrap type
            wrap_types = ['wrapNone', 'wrapSquare', 'wrapTight', 'wrapThrough', 'wrapTopAndBottom']
            for wt in wrap_types:
                if el.find(f'wp:{wt}', ns) is not None:
                    info['wrap'] = wt
                    break

            # Determine CSS class based on positioning
            if info.get('is_right') and info.get('wrap') in ('wrapTight', 'wrapThrough', 'wrapSquare'):
                info['css_class'] = 'img-float-right'
            elif info.get('wrap') == 'wrapTopAndBottom':
                info['css_class'] = 'img-block-center'
            elif w_in > 4:
                info['css_class'] = 'img-block-wide'
            else:
                info['css_class'] = 'img-block-center'
        else:
            # Inline images
            if w_in < 0.5:
                info['css_class'] = 'img-icon'
            else:
                info['css_class'] = 'img-inline'

        # Add intended CSS width — convert tall portrait floated images to constrained centered blocks
        if info.get('css_class') == 'img-float-right' and h_in > w_in * 1.15:
            # Portrait images shouldn't float — they create too much dead space
            # Use the portrait-specific class with max-height constraint
            info['css_class'] = 'img-block-center-portrait'
            info['css_width'] = f'{min(w_in * 0.55, 1.6):.1f}in'
        else:
            info['css_width'] = f'{w_in:.1f}in'

        images.append(info)

    return images


if __name__ == '__main__':
    images = extract_image_positions(DOCX)
    for img in images:
        print(f"{img['filename']:30s} {img['type']:8s} {img['width_in']:.2f}x{img['height_in']:.2f}in "
              f"css={img['css_class']:20s} width={img['css_width']}")

    # Save as JSON for use by converter
    with open('image_positions.json', 'w') as f:
        json.dump(images, f, indent=2)
    print(f"\nSaved {len(images)} image positions to image_positions.json")
