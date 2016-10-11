PLAT ?= none
PLATS = linux freebsd macosx

CC ?= gcc

.PHONY : none $(PLATS) clean all

#ifneq ($(PLAT), none)

.PHONY : default

default :
	$(MAKE) $(PLAT)

#endif

none :
	@echo "Please do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "   $(PLATS)"

OWLIES_LIBS := -lpthread -lm
SHARED := -fPIC --shared

linux : PLAT = linux
macosx : PLAT = macosx
freebsd : PLAT = freebsd

macosx : SHARED := -fPIC -dynamiclib -Wl,-undefined,dynamic_lookup
macosx : EXPORT :=
macosx linux : OWLIES_LIBS += -ldl
linux freebsd : OWLIES_LIBS += -lrt

linux macosx freebsd :
	$(MAKE) all PLAT=$@ OWLIES_LIBS="$(OWLIES_LIBS)" SHARED="$(SHARED)"