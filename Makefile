TARGET	= asix
OBJS	= asix.o
MDIR	= misc
ifeq ($(KVER),)
KVER	= $(shell uname -r)
endif
KDIR	= /lib/modules/$(KVER)/build
SUBLEVEL= $(shell uname -r | cut -d '.' -f 3 | cut -d '.' -f 1 | cut -d '-' -f 1 | cut -d '_' -f 1)

EXTRA_CFLAGS = -DEXPORT_SYMTAB
PWD = $(shell pwd)
DEST = /lib/modules/$(KVER)/$(MDIR)

obj-m      := $(TARGET).o

default:
	make -C $(KDIR) SUBDIRS=$(PWD) modules

$(TARGET).o: $(OBJS)
	$(LD) $(LD_RFLAG) -r -o $@ $(OBJS)

install:
	[ -d $(DEST) ] || mkdir -p $(DEST) 2>/dev/null
	cp -v $(TARGET).ko $(DEST) && /sbin/depmod -a $(KVER)

clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean

.PHONY: modules clean

-include $(KDIR)/Rules.make
