

DIR_PATH := /tmp/spartan
DST_DIR := /tmp/results

PATH_REFIX :=
PATH_SUFFIX :=


# Create destination directory if it doesn't exist
$(shell mkdir -p $(DST_DIR))

# Find all .o files in the current directory
OBJ_FILES := $(shell find ${DIR_PATH} -name "*.o")



copy_all:
	@echo "Copying files..."
	@for f in $(OBJ_FILES); do \
		kernel_name=$$( echo $$f | sed "s/.*${PATH_REFIX}\(.*\)${PATH_SUFFIX}.*/\1/");\
		echo "Kernel found $$kernel_name";\
		cp $$f $(DST_DIR)/$$kernel_name.ll; \
		echo "Copied $$f to $(DST_DIR)/$$kernel_name.ll"; \
	done
	
	@echo "Done copying files"


# Find all .ll files in DST_DIR
LL_FILES := $(wildcard $(DST_DIR)/*.ll)

# Generate corresponding .o files
COMPILED_FILES := $(LL_FILES:.ll=.asm)

# Create targets for each .ll file in DST_DIR
TEMP_FILES := $(shell find ${DST_DIR} -name "*.ll")
$(DST_DIR)/%.asm: $(DST_DIR)/*.ll
	@echo "Compiling $<..."
	llc -start-before=${PASS_START} $< -o $@

compile: $(COMPILED_FILES)
	@echo "All .ll files have been compiled."

.PHONY: all clean copy_all compile

all: copy_all compile

# Optional: Clean target
clean:
	rm -f *.o