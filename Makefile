UNAME_S = $(shell uname -s)

CC = clang
CFLAGS = -std=c11 -O3 -g -Wall -Wextra -Wpedantic -Wstrict-aliasing
CFLAGS += -Wno-pointer-arith -Wno-newline-eof -Wno-unused-parameter -Wno-gnu-statement-expression
CFLAGS += -Wno-gnu-compound-literal-initializer -Wno-gnu-zero-variadic-macro-arguments
CFLAGS += -Ilib/cglm/include -Ilib/glad/include -Ilib/glfw/include -Ilib/stb -Ilib/noise -fbracket-depth=1024
LDFLAGS = lib/glad/src/glad.o lib/cglm/.libs/libcglm.a lib/glfw/src/libglfw3.a lib/noise/noise1234.o -lm
LIBFLAGS = -c

# GLFW required frameworks on OSX
ifeq ($(UNAME_S), Darwin)
	LDFLAGS += -framework OpenGL -framework IOKit -framework CoreVideo -framework Cocoa
endif

SRC = $(wildcard src/**/*.c) $(wildcard src/*.c) $(wildcard src/**/**/*.c) $(wildcard src/**/**/**/*.c)
OBJ = $(SRC:.c=.o)
LIB = $(wildcard lib/**/*.c) $(wildcard lib/*.c) $(wildcard lib/**/**/*.c) $(wildcard lib/**/**/**/*.c)
BIN = bin

.PHONY: all clean

all: libs dirs game

dirs:
	mkdir -p ./$(BIN)

run: all
	$(BIN)/game

game: $(OBJ)
	$(CC) -o $(BIN)/game $^ $(LDFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

libs:
	$(foreach i,$(LIB),$(CC) $(LIBFLAGS) $i -o $(basename $i).o;)

clean:
	rm -rf $(BIN) $(OBJ)