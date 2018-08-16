# Process a PDF with OCR to add a searchable text layer
function ocr
  docker run -it --rm -v (pwd):/~ petpaulsen/ocr $argv
end