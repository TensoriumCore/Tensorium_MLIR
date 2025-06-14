MLIR_OPT=mlir-opt
MLIR_TRANSLATE=mlir-translate
LLC=llc
CLANG=clang++

MLIR_SRC=$(wildcard generated/*.mlir)
LLVMDIR=build

MLIR_LOWERED=$(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.lowered.mlir)
LLVM_IR=$(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.ll)
LLVM_OBJ=$(MLIR_SRC:generated/%.mlir=$(LLVMDIR)/%.o)

all: test_metrics

$(LLVMDIR)/%.lowered.mlir: generated/%.mlir
	$(MLIR_OPT) \
		--convert-math-to-llvm \
		--convert-arith-to-llvm \
		--convert-func-to-llvm \
		--reconcile-unrealized-casts \
		$< -o $@

$(LLVMDIR)/%.ll: $(LLVMDIR)/%.lowered.mlir
	$(MLIR_TRANSLATE) --mlir-to-llvmir $< -o $@

$(LLVMDIR)/%.o: $(LLVMDIR)/%.ll
	$(LLC) -filetype=obj $< -o $@

test_metrics: main_test.cpp $(LLVM_OBJ)
	$(CLANG) -O3 $^ -o $@

clean:
	rm -f $(LLVMDIR)/* test_metrics
