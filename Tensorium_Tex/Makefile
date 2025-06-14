MLIR_OPT     ?= mlir-opt
MLIR_TRANS   ?= mlir-translate
SRC_DIR      := generated
OUT_DIR      := build
GPU_TARGET   ?= none  # Options: none, nvvm, rocdl, spirv

SRC_FILES    := $(wildcard $(SRC_DIR)/*.mlir)
LLVM_FILES   := $(patsubst $(SRC_DIR)/%.mlir, $(OUT_DIR)/%.ll, $(SRC_FILES))

# Default target
all: $(LLVM_FILES)

# Convert MLIR to LLVM IR
$(OUT_DIR)/%.ll: $(SRC_DIR)/%.mlir | $(OUT_DIR)
	$(MLIR_OPT) \
		--convert-math-to-llvm \
		--convert-arith-to-llvm \
		--convert-func-to-llvm \
		--reconcile-unrealized-casts \
		$< -o $(OUT_DIR)/$*.lowered.mlir

ifeq ($(GPU_TARGET),nvvm)
	$(MLIR_OPT) --convert-gpu-to-nvvm $(OUT_DIR)/$*.lowered.mlir -o $(OUT_DIR)/$*.gpu.mlir
	$(MLIR_TRANS) --mlir-to-llvmir $(OUT_DIR)/$*.gpu.mlir -o $@
else ifeq ($(GPU_TARGET),rocdl)
	$(MLIR_OPT) --convert-gpu-to-rocdl $(OUT_DIR)/$*.lowered.mlir -o $(OUT_DIR)/$*.gpu.mlir
	$(MLIR_TRANS) --mlir-to-llvmir $(OUT_DIR)/$*.gpu.mlir -o $@
else ifeq ($(GPU_TARGET),spirv)
	$(MLIR_OPT) --convert-gpu-to-spirv $(OUT_DIR)/$*.lowered.mlir -o $(OUT_DIR)/$*.gpu.mlir
	$(MLIR_TRANS) --mlir-to-spirv $(OUT_DIR)/$*.gpu.mlir -o $@
else
	$(MLIR_TRANS) --mlir-to-llvmir $(OUT_DIR)/$*.lowered.mlir -o $@
endif

# Ensure output dir exists
$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# Clean
clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean

