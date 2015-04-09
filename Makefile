# -------------------------------------------------------------------------------------------------
# Define where to find the standard locale source files
I18Nlocales := /usr/share/i18n/locales

# Define where to find the local modified locale source files
locales := ./locales
charmaps := ./charmaps

# The UTF-8 symbol value for the "/" (slash) character.
# Needed, while the "copy" statement in the locale source files read by "localedef" removes "/"
# characters in the path name, but accepts and uses the UTF-8 symbol value currectly!
SLASH := <U002F>


# -------------------------------------------------------------------------------------------------
# Listing of all the SAP specific locales this Makefile handles
         SAP_GERMAN_HP := de_DE
     SAP_GERMAN_HP_SRC := $(locales)/$(SAP_GERMAN_HP)@HP
 SAP_GERMAN_HP_COLLATE := $(locales)/iso14651_HP
    SAP_GERMAN_HP_I18N := $(locales)/i18n@SAP
 SAP_GERMAN_HP_CHARMAP := ISO-8859-1
  SAP_GERMAN_HP_LOCALE := locale/$(SAP_GERMAN_HP).iso88591@SAP_HP

           SAP_ESTOIAN := et_EE
       SAP_ESTOIAN_SRC := $(SAP_ESTOIAN)
   SAP_ESTOIAN_CHARMAP := ISO-8859-4
    SAP_ESTOIAN_LOCALE := locale/$(SAP_ESTOIAN).iso88594@SAP

        SAP_LITHUANIEN := lt_LT
    SAP_LITHUANIEN_SRC := $(SAP_LITHUANIEN)
SAP_LITHUANIEN_CHARMAP := ISO-8859-4
 SAP_LITHUANIEN_LOCALE := locale/$(SAP_LITHUANIEN).iso88594@SAP

           SAP_LATVIAN := lv_LV
       SAP_LATVIAN_SRC := $(SAP_LATVIAN)
   SAP_LATVIAN_CHARMAP := ISO-8859-4
    SAP_LATVIAN_LOCALE := locale/$(SAP_LATVIAN_SRC).iso88594@SAP

            SAP_KOREAN := ko_KR
        SAP_KOREAN_SRC := $(SAP_KOREAN)
    SAP_KOREAN_CHARMAP := EUC-KR
     SAP_KOREAN_LOCALE := locale/$(SAP_KOREAN).euckr@SAP

             SAP_CZECH := cs_CZ
         SAP_CZECH_SRC := $(locales)/$(SAP_CZECH)@SAP
     SAP_CZECH_CHARMAP := ISO-8859-2
      SAP_CZECH_LOCALE := locale/$(SAP_CZECH).iso88592@SAP

            SAP_SLOVAK := sk_SK
        SAP_SLOVAK_SRC := $(locales)/$(SAP_SLOVAK)@SAP
    SAP_SLOVAK_COLLATE := $(SAP_CZECH_SRC)
    SAP_SLOVAK_CHARMAP := ISO-8859-2
     SAP_SLOVAK_LOCALE := locale/$(SAP_SLOVAK).iso88592@SAP

           SAP_TURKISH := tr_TR
       SAP_TURKISH_SRC := $(locales)/$(SAP_TURKISH)@SAP
   SAP_TURKISH_CHARMAP := ISO-8859-9
    SAP_TURKISH_LOCALE := locale/$(SAP_TURKISH).iso88599@SAP

          SAP_JAPANESE := ja_JP
      SAP_JAPANESE_SRC := $(SAP_JAPANESE)
  SAP_JAPANESE_CHARMAP := $(charmaps)/SAPSJIS
   SAP_JAPANESE_LOCALE := locale/$(SAP_JAPANESE).SAPSJIS


# -------------------------------------------------------------------------------------------------
# Define all the locales that this Makefile is building
LOCALESToDo := GERMAN_HP ESTOIAN LITHUANIEN LATVIAN KOREAN CZECH TURKISH JAPANESE SLOVAK

GEN_LOCALES := $(foreach v,$(LOCALESToDo),$(SAP_$(v)_LOCALE))


# -------------------------------------------------------------------------------------------------
all: locales iconv

locales: locale $(GEN_LOCALES)
locale:
	mkdir -p $@

iconv: gconv gconvdata
gconv:
	mkdir -p $@/gconv-modules.d
	cp gconv-modules.SAP $@/gconv-modules.d/SAP

.PHONY: gconvdata
gconvdata:
	make -C gconvdata all
	mv gconvdata/SAPSJIS.so gconv/SAPSJIS.so

clean:
	$(RM) $(SAP_GERMAN_HP_SRC)
	$(RM) $(SAP_SLOVAK_SRC)
	$(RM) -r $(GEN_LOCALES)
	[ ! -d locale ] || rmdir locale
	rm -f gconv/gconv-modules.d/SAP
	[ ! -d gconv/gconv-modules.d ] || rmdir gconv/gconv-modules.d
	for dir in gconv; do \
	  rm -f $$dir/*.so $$dir/gconv-modules.SAP; \
	  [ ! -d $$dir ] || rmdir $$dir; \
	done
	make -C gconvdata clean

distclean: clean

# -------------------------------------------------------------------------------------------------
# Build the locale locales into "./locale" using the sources from "locales", when needed

$(SAP_GERMAN_HP_LOCALE): $(SAP_GERMAN_HP_SRC)
	localedef -ci $(SAP_GERMAN_HP_SRC) -f $(SAP_GERMAN_HP_CHARMAP) $(SAP_GERMAN_HP_LOCALE)

$(SAP_GERMAN_HP_SRC): $(I18Nlocales)/$(SAP_GERMAN_HP) $(SAP_GERMAN_HP_I18N)
	sed -e \
	    's;copy "iso14651_t1";copy "$(subst /,$(SLASH),$(SAP_GERMAN_HP_COLLATE))";' \
	    -e \
		's;copy "i18n";copy "$(subst /,$(SLASH),$(SAP_GERMAN_HP_I18N))";' \
	    $(I18Nlocales)/$(SAP_GERMAN_HP) >$@

$(SAP_ESTOIAN_LOCALE):
	localedef -ci $(SAP_ESTOIAN_SRC) -f $(SAP_ESTOIAN_CHARMAP) $(SAP_ESTOIAN_LOCALE)

$(SAP_LITHUANIEN_LOCALE):
	localedef -ci $(SAP_LITHUANIEN_SRC) -f $(SAP_LITHUANIEN_CHARMAP) $(SAP_LITHUANIEN_LOCALE)

$(SAP_LATVIAN_LOCALE):
	localedef -ci $(SAP_LATVIAN_SRC) -f $(SAP_LATVIAN_CHARMAP) $(SAP_LATVIAN_LOCALE)

$(SAP_KOREAN_LOCALE):
	localedef -ci $(SAP_KOREAN_SRC) -f $(SAP_KOREAN_CHARMAP) $(SAP_KOREAN_LOCALE)

$(SAP_CZECH_LOCALE): $(SAP_CZECH_SRC)
	localedef -ci $(SAP_CZECH_SRC) -f $(SAP_CZECH_CHARMAP) $(SAP_CZECH_LOCALE)

$(SAP_SLOVAK_SRC): $(I18Nlocales)/$(SAP_SLOVAK_HP)
	sed -e \
	    's;copy "cs_CZ";copy "$(subst /,$(SLASH),$(SAP_SLOVAK_COLLATE))";' \
		-e \
		's;copy "i18n";copy "$(subst /,$(SLASH),$(SAP_GERMAN_HP_I18N))";' \
	    $(I18Nlocales)/$(SAP_SLOVAK) >$@

$(SAP_SLOVAK_LOCALE): $(SAP_SLOVAK_SRC)
	localedef -ci $(SAP_SLOVAK_SRC) -f $(SAP_SLOVAK_CHARMAP) $(SAP_SLOVAK_LOCALE)

$(SAP_TURKISH_LOCALE): $(SAP_TURKISH_SRC)
	localedef -ci $(SAP_TURKISH_SRC) -f $(SAP_TURKISH_CHARMAP) $(SAP_TURKISH_LOCALE)

$(SAP_JAPANESE_LOCALE): $(SAP_JAPANESE_CHARMAP)
	localedef -ci $(SAP_JAPANESE_SRC) -f $(SAP_JAPANESE_CHARMAP) $(SAP_JAPANESE_LOCALE)
