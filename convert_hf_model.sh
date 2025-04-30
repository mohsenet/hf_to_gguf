#!/bin/bash

# Sample of model
# hf_user/hf_model
# https://huggingface.co/hf_user/hf_model

# === CONFIGURATION ===
MODEL_NAME="hf_user/hf_model"
OUTPUT_DIR="./hf_user-gguf"
GGUF_MODEL="$OUTPUT_DIR/hf_user.gguf"
QUANTIZED_MODEL="$OUTPUT_DIR/hf_user-Q4_K_M.gguf"
QUANT_TYPE="q4_k_m"  # Change if you want q8_0, q5_0, etc.
LOCAL_MODEL_DIR="$OUTPUT_DIR/local_model"

# === CREATE OUTPUT DIR ===
mkdir -p "$OUTPUT_DIR" "$LOCAL_MODEL_DIR"

# === DOWNLOAD MODEL FROM HUGGING FACE ===
echo "📥 Downloading model: $MODEL_NAME"
python3 -c "
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained('$MODEL_NAME', use_safetensors=True)
tokenizer = AutoTokenizer.from_pretrained('$MODEL_NAME')

model.save_pretrained('$LOCAL_MODEL_DIR')
tokenizer.save_pretrained('$LOCAL_MODEL_DIR')
"

# === CLONE LLAMA.CPP IF NOT ALREADY DONE ===
if [ ! -d "llama.cpp" ]; then
  echo "📦 Cloning llama.cpp..."
  git clone https://github.com/ggerganov/llama.cpp
fi

cd llama.cpp || exit 1
git pull

# === CONVERT TO GGUF ===
echo "🔄 Converting to GGUF format..."
python tools/convert_hf_to_gguf.py "$LOCAL_MODEL_DIR" --outfile "$GGUF_MODEL" --outtype float16

# === QUANTIZE THE MODEL ===
echo "✂️ Quantizing model to $QUANT_TYPE..."
./quantize "$GGUF_MODEL" "$QUANTIZED_MODEL" "$QUANT_TYPE"

# === CLEAN UP (uncomment to enable) ===
# rm -rf "$LOCAL_MODEL_DIR"

# === DONE ===
echo "✅ Conversion completed!"
echo "📍 GGUF model saved at: $GGUF_MODEL"
echo "📍 Quantized model saved at: $QUANTIZED_MODEL"
