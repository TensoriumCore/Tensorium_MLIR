MLIR_OPT = mlir-opt
MLIR_TRANSLATE = mlir-translate
LLC = llc
CLANG = clang++

MLIR_SRC = $(wildcard generated/*.mlir)
LLVMDIR = build

MLIR_LOWERED = $(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.lowered.mlir)
LLVM_IR      = $(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.ll)
LLVM_OBJ     = $(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.o)

.PHONY: all clean
all: test_metrics

# Ensure the build directory exists
$(LLVMDIR):
	mkdir -p $(LLVMDIR)

# Lower MLIR to LLVM dialect (drop arith, scf, cf, func into LLVM ops)
$(LLVMDIR)/%.lowered.mlir: generated/%.mlir | $(LLVMDIR)
	$(MLIR_OPT) \
		--convert-math-to-llvm \
		--convert-scf-to-cf \
		--convert-cf-to-llvm \
		--convert-arith-to-llvm \
		--convert-func-to-llvm \
		--finalize-memref-to-llvm \
		--reconcile-unrealized-casts \
		$< -o $@

# Translate MLIR LLVM dialect to LLVM IR
$(LLVMDIR)/%.ll: $(LLVMDIR)/%.lowered.mlir | $(LLVMDIR)
	$(MLIR_TRANSLATE) --mlir-to-llvmir $< -o $@

# Compile LLVM IR to object file
$(LLVMDIR)/%.o: $(LLVMDIR)/%.ll | $(LLVMDIR)
	$(LLC) -O3 -filetype=obj $< -o $@

# Link and build the test executable
test_metrics: main_test.cpp $(LLVM_OBJ)
	$(CLANG) -g -O3 $^ -o $@

# Clean generated files
clean:
	rm -rf $(LLVMDIR)/* test_metrics
