CC = gcc
CFLAGS = -Wall -Wshadow -Wextra -Werror -flto -O3
IN = src/*.c
OUT = parsELF_C

SRCS = $(wildcard $(IN))
OBJS = $(SRCS:.c=.o)

.PHONY: all debug clean

all: $(OUT)

$(OUT): $(OBJS)
	$(CC) $(OBJS) -o $(OUT) $(CFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

debug: $(OBJS)
	$(CC) $(OBJS) -o $(OUT)-dbg $(CFLAGS) -g

clean:
	rm -f $(OUT) $(OUT)-dbg

