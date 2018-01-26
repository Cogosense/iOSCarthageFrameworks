TOPDIR = $(CURDIR)

BUILT_PRODUCTS_DIR ?= $(TOPDIR)/build

FRAMEWORK_NAME = iOSDFULibrary
FRAMEWORKBUNDLE = $(FRAMEWORK_NAME).framework
DEP_FRAMEWORKBUNDLES = Zip.framework
CARTHAGE_BUILDDIR = $(TOPDIR)/Carthage/Build/iOS

ALL_FRAMEWORKBUNDLES = $(addprefix $(CARTHAGE_BUILDDIR)/, $(FRAMEWORKBUNDLE) $(DEP_FRAMEWORKBUNDLES))
ALL_TARBALLS = $(addsuffix .tar.bz2, $(FRAMEWORKBUNDLE) $(DEP_FRAMEWORKBUNDLES))

all : $(ALL_FRAMEWORKBUNDLES) $(ALL_TARBALLS)

$(ALL_FRAMEWORKBUNDLES):
	carthage update --verbose --platform iOS

%.tar.bz2 : $(CARTHAGE_BUILDDIR)/%
	tar -C $(<D) -cjf $@ $(<F)

install :

clean:
	$(RM) -r Carthage
	$(RM) Cartfile.resolved $(ALL_TARBALLS)
