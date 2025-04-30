# 🧠 `hf_model` GGUF Conversion Script

---


`hf_user`: Huggingface user<br>
`hf_model`: Huggingface model

Example:

https://huggingface.co/`microsoft`/`bitnet-b1.58-2B-4T`<br>
`hf_user`: microsoft<br>
`hf_model`: bitnet-b1.58-2B-4T

---

This repository contains a Bash script to convert the [hf_user/hf_model](https://huggingface.co/hf_user/hf_model) model from Hugging Face into **GGUF format**, compatible with [`llama.cpp`](https://github.com/ggerganov/llama.cpp), and optionally **quantize** it for faster performance on CPU.

---

## 📦 What Does This Script Do?

The script performs the following steps:

1. 📥 Downloads the `hf_model` model from Hugging Face (with `.safetensors` support).
2. ⚙️ Converts the model to **GGUF** format using `llama.cpp`.
3. ✂️ Optionally **quantizes** the model to reduce size and improve inference speed.
4. 🗃️ Saves the converted models to a local directory for easy use.

---

## 🧰 Requirements

Make sure you have these installed before running the script:

| Tool            | Required? | Notes |
|-----------------|-----------|-------|
| Git             | ✅        | For cloning `llama.cpp` |
| Python 3        | ✅        | With `torch`, `transformers`, and `safetensors` |
| Bash shell      | ✅        | Works best on Linux/macOS or WSL |
| Internet access | ✅        | To download the model |

Install dependencies:

```bash
pip install torch transformers safetensors
```

---

## ▶️ How to Use

1. Clone this repo or create a new folder and add the script:
   ```bash
   mkdir hf_model-GGUF
   cd hf_model-GGUF
   cp /path/to/convert_hf_model.sh .
   ```

2. Make the script executable:
   ```bash
   chmod +x convert_hf_model.sh
   ```

3. Run the script:
   ```bash
   ./convert_hf_model.sh
   ```

4. When done, find your converted models in:
   ```
   ./hf_model-gguf/
   ```

---

## 📁 Output Files

| File | Description |
|------|-------------|
| `hf_model.gguf` | Full precision (FP16) GGUF model |
| `hf_model-Q4_K_M.gguf` | Quantized version using Q4_K_M method (smaller/faster) |

You can change the quantization type in the script by modifying:
```bash
QUANT_TYPE="q4_k_m"
```
to any valid type like:
- `q2_k`
- `q3_k`
- `q4_0`
- `q5_0`
- `q8_0`

---

## 🧪 Test Your Model

After conversion:

```bash
cd llama.cpp
./llama-cli -m ../hf_model-gguf/hf_model-Q4_K_M.gguf -p "How are you today?"
```

Watch the model respond!

---

## 📝 Notes

- The `hf_model` model is based on the Mistral architecture, which is well-supported by `llama.cpp`.
- If you encounter issues with tokenizer loading, try setting `--no-use_fast` in the Python download section.
- You can delete the downloaded model files after conversion to save space (commented out in script).

---

## 🤝 Credits

- [Hugging Face](https://huggingface.co/) – for hosting the original model
- [llama.cpp](https://github.com/ggerganov/llama.cpp) – for enabling fast LLM inference
- [hf_user](https://huggingface.co/hf_user) – for releasing the `hf_model` model

---

## 📄 License

MIT License – Feel free to modify and share this script.
