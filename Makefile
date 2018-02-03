TOPDIR = $(CURDIR)

BUILT_PRODUCTS_DIR ?= $(TOPDIR)/build

FRAMEWORK_NAME = iOSDFULibrary
FRAMEWORKBUNDLE = $(FRAMEWORK_NAME).framework
DEP_FRAMEWORKBUNDLES = Zip.framework
CARTHAGE_BUILDDIR = $(TOPDIR)/Carthage/Build/iOS

ALL_FRAMEWORKBUNDLES = $(addprefix $(CARTHAGE_BUILDDIR)/, $(FRAMEWORKBUNDLE) $(DEP_FRAMEWORKBUNDLES))
ALL_TARBALLS = $(addsuffix .tar.bz2, $(FRAMEWORKBUNDLE) $(DEP_FRAMEWORKBUNDLES))
BUILT_PRODUCTS_FRAMEWORKBUNDLES = $(addprefix $(BUILT_PRODUCTS_DIR)/, $(FRAMEWORKBUNDLE) $(DEP_FRAMEWORKBUNDLES))

all install : $(ALL_FRAMEWORKBUNDLES) $(ALL_TARBALLS) $(BUILT_PRODUCTS_FRAMEWORKBUNDLES)

$(ALL_FRAMEWORKBUNDLES):
	carthage checkout
	(cd Carthage/Checkouts/IOS-Pods-DFU-Library && patch -p1 < ../../../legacy-dfu-activating-state.patch)
	carthage build --verbose --platform iOS

%.tar.bz2 : $(CARTHAGE_BUILDDIR)/%
	tar -C $(<D) -cjf $@ $(<F)

$(BUILT_PRODUCTS_DIR)/% : %.tar.bz2
	mkdir -p $(@D)
	tar -C $(@D) -xmf $<

clean:
	$(RM) -r Carthage
	$(RM) $(ALL_TARBALLS)
	$(RM) -r $(BUILT_PRODUCTS_FRAMEWORKBUNDLES)
	$(RM) -r build
