# JPEG Compression & Reconstruction Implementation
## Overview

This project presents a complete implementation of the **JPEG compression and decompression pipeline in MATLAB**, developed as part of the CYSE 729 – Multimedia Security course.

The system implements all major stages of the JPEG encoder and decoder, including:

- Color space conversion (RGB ↔ YCbCr)
- 4:2:0 chroma subsampling
- 8×8 block-based DCT transformation
- High-frequency coefficient suppression (zig-zag masking)
- Quantization with adjustable quality factor
- Huffman entropy encoding
- Full reconstruction pipeline

The reconstruction process accurately reverses all compression stages to regenerate the image as closely as possible to the original.

---

## Objective

The goal of this project was to design and implement:

- `compress()` – Complete JPEG compression pipeline  
- `reconst()` – Complete JPEG reconstruction pipeline  

Two key parameters control compression behavior:

- **Q (1–100)** → Quality factor controlling quantization strength  
- **thr (1–64)** → Number of zig-zag coefficients retained per 8×8 block  

---

## JPEG Compression Pipeline

The compression process consists of the following stages:

### RGB to YCbCr Conversion
Transforms input RGB image into:
- Y (Luminance)
- Cb (Chrominance Blue)
- Cr (Chrominance Red)

---

### 4:2:0 Chroma Subsampling
- Cb and Cr are averaged over 2×2 regions
- Reduces color redundancy
- Optional visualization to compare original vs subsampled output

---

### 8×8 Block Partitioning
- Image padded to dimensions divisible by 8
- Each channel divided into 8×8 blocks

---

### 2-D Discrete Cosine Transform (DCT)
- `dct2` applied to each block
- Converts spatial information to frequency domain

---

### High-Frequency Removal
- Zig-zag mask generated
- Only first `thr` coefficients retained
- Remaining high-frequency components set to zero

---

### Quantization
- Standard JPEG luminance and chrominance tables used
- Tables scaled using quality factor **Q**
- Coefficients quantized accordingly

---

### Huffman Encoding
- Quantized coefficients entropy encoded
- Binary bitstream generated

---

## Reconstruction Pipeline

The decompression process reverses all compression stages:

1. Huffman decoding  
2. Dequantization  
3. Inverse DCT (`idct2`)  
4. Chroma upsampling (nearest neighbor interpolation)  
5. Removal of padding  
6. YCbCr to RGB conversion  

The final reconstructed image matches the original dimensions.

---

## Implemented Functions

| Function | Description |
|----------|-------------|
| `compress_image()` | Executes full compression pipeline |
| `subsample420()` | Performs 4:2:0 chroma subsampling |
| `block8x8()` | Pads and partitions image into 8×8 blocks |
| `dct8x8()` | Applies 2-D DCT per block |
| `zigzag_mask()` / `apply_mask()` | Retains first `thr` coefficients |
| `std_quant_tables()` | Creates standard quantization tables |
| `quantize_block()` | Performs coefficient quantization |
| `dequantize_block()` | Performs inverse quantization |
| `inverse_dct8x8()` | Applies inverse DCT |
| `build_huffman_dict()` | Builds Huffman dictionary |
| `huffman_encode()` | Encodes bitstream |
| `huffman_decode()` | Decodes bitstream |
| `reconst()` | Executes full reconstruction pipeline |
| `upsample420()` | Performs chroma upsampling |
| `unblockify8()` | Removes padding |
| `zigzag()` | Generates zig-zag scan order |

---

## Implementation Notes

- Designed to minimize explicit loops  
- Utilizes MATLAB built-in functions such as `blockproc`
- Edge padding handled via replication
- Pixel values clipped to [0,255] before `uint8` conversion to prevent overflow
- Debugging validated using:
  - Symbol count verification
  - PSNR comparison
  - Step-by-step visualization

---

## Key Features

- Adjustable quality factor (Q)
- Adjustable frequency retention (thr)
- Modular pipeline design
- Fully reversible compression process
- MATLAB-based block processing implementation

---

## Requirements

- MATLAB
- Image Processing Toolbox (recommended)

---

## Academic Context

This project was developed for:

**CYSE 729 – Multimedia Security**  
College of Science & Engineering  
Hamad Bin Khalifa University  

---

## License

This project is intended for academic and educational purposes.
