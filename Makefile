# Default Makefile template for C/C++ projects
# Juan Pablo de la Cruz Gutierrez
#
# This makefie is released in terms of the GPL3 license.
# See http://www.gnu.org/licenses/gpl-3.0.en.html for details.

INCLUDES = -I.
# LIBS = -L.

STATE=debug
COMP=gcc

STATE=release
ifeq ($(STATE),release)
CFLAGS=-O3
endif

ifeq ($(STATE),debug)
CFLAGS=-g -O0
endif

ifeq ($(STATE),profile)
CFLAGS=-g -pg -O3
endif

ifeq ($(COMP),icc)
CC = icc
CFLAGS += -Wall -openmp -DBOUNDARY=32 -xHost -vec-report5 -std=c11
LDFLAGS = -lm
endif

ifeq ($(COMP),gcc)
CC = gcc
CFLAGS = -Wall -O3 -fopenmp -std=c11 -DBOUNDARY=32 -march=native \
	 			 -ftree-vectorizer-verbose=1 -ftree-vectorize -g

LDFLAGS = -lm -lgomp
endif

# call make print-VARNAME to display its value
print-%:
	@echo '$*=$($*)'
	@echo 'origin $*=$(origin $*)'
	@echo 'flavor $*=$(flavor $*)'
	@echo 'value $*=$(value $*)'

# pass it as an argument to the makefile
# It is expected that the file src/$(PROG).c exists
# PROG := algebra
SRCDIR := src
OBJDIR := obj
SRCS := $(notdir $(wildcard $(SRCDIR)/*.c))
OBJS := $(patsubst %.c,%.o,$(SRCS))

.PHONY:	all clean asm $(PROG)

all: $(PROG)

%.o:$(SRCDIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $(OBJDIR)/$@

asm: $(PROG).s

%.s:$(SRCDIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -S -masm=intel $<

$(PROG): $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $@ $(addprefix $(OBJDIR)/,$^) $(LDFLAGS)
ifeq ($(STATE),release)
	-strip -s $(PROG)
endif

clean:
	-rm -f $(OBJDIR)/* $(PROG) *.s 1

