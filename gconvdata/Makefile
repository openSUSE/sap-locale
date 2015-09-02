CFLAGS += \
-O \
-Wall -Winline -Wstrict-prototypes -Wwrite-strings \
-fno-strength-reduce -fPIC \
-D_LIBC_REENTRANT -DPIC -DSHARED -D_GNU_SOURCE=1 -D_REENTRANT=1 \
-I.

LDFLAGS += -shared

modules = SAPSJIS.so

ifeq ($(32bit),yes)
  CFLAGS += -m32
  LDFLAGS += -m32
endif


all: $(modules)

clean:
	rm -rf *.so *.o


%.so: %.o
	$(CC) $(LDFLAGS) -o $@ $<
