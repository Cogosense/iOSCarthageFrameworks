TOPDIR = $(CURDIR)

BUILT_PRODUCTS_DIR ?= $(TOPDIR)/build
CARTHAGE_SRCDIR = $(TOPDIR)/Carthage/Checkouts
CARTHAGE_BUILDDIR = $(TOPDIR)/Carthage/Build/iOS

all install : iOSDFULibrary.framework UICircularProgressRing.framework PopupDialog.framework

# ======== iOSDFULibrary (Zip)  ===========

IOSDFULIBRARY_SRCDIR = $(CARTHAGE_SRCDIR)/IOS-Pods-DFU-Library
IOSDFULIBRARY_FRAMEWORKS = iOSDFULibrary.framework Zip.framework
IOSDFULIBRARY_FRAMEWORKBUNDLES = $(addprefix $(CARTHAGE_BUILDDIR)/, $(IOSDFULIBRARY_FRAMEWORKS))
IOSDFULIBRARY_TARBALLS = $(addsuffix .tar.bz2, $(IOSDFULIBRARY_FRAMEWORKS))
IOSDFULIBRARY_BUILT_PRODUCTS = $(addprefix $(BUILT_PRODUCTS_DIR)/, $(IOSDFULIBRARY_FRAMEWORKS))

$(IOSDFULIBRARY_FRAMEWORKS): $(IOSDFULIBRARY_SRCDIR) $(IOSDFULIBRARY_FRAMEWORKBUNDLES) $(IOSDFULIBRARY_TARBALLS) $(IOSDFULIBRARY_BUILT_PRODUCTS)

$(IOSDFULIBRARY_SRCDIR) :
	carthage checkout IOS-Pods-DFU-Library
	(cd Carthage/Checkouts/IOS-Pods-DFU-Library && patch -p1 < ../../../legacy-dfu-activating-state.patch)

$(IOSDFULIBRARY_FRAMEWORKBUNDLES) :
	carthage build --verbose --platform iOS IOS-Pods-DFU-Library

CLEANFILES += $(IOSDFULIBRARY_TARBALLS) $(IOSDFULIBRARY_BUILT_PRODUCTS)

# ======== UICircularProgressRing ===========

UICIRCULARPROGRESSRING_SRCDIR = $(CARTHAGE_SRCDIR)/UICircularProgressRing
UICIRCULARPROGRESSRING_FRAMEWORKS = UICircularProgressRing.framework
UICIRCULARPROGRESSRING_FRAMEWORKBUNDLES = $(addprefix $(CARTHAGE_BUILDDIR)/, $(UICIRCULARPROGRESSRING_FRAMEWORKS))
UICIRCULARPROGRESSRING_TARBALLS = $(addsuffix .tar.bz2, $(UICIRCULARPROGRESSRING_FRAMEWORKS))
UICIRCULARPROGRESSRING_BUILT_PRODUCTS = $(addprefix $(BUILT_PRODUCTS_DIR)/, $(UICIRCULARPROGRESSRING_FRAMEWORKS))

$(UICIRCULARPROGRESSRING_FRAMEWORKS) : $(UICIRCULARPROGRESSRING_SRCDIR) $(UICIRCULARPROGRESSRING_FRAMEWORKBUNDLES) $(UICIRCULARPROGRESSRING_TARBALLS) $(UICIRCULARPROGRESSRING_BUILT_PRODUCTS)

$(UICIRCULARPROGRESSRING_SRCDIR) :
	carthage checkout UICircularProgressRing

$(UICIRCULARPROGRESSRING_FRAMEWORKBUNDLES) :
	carthage build --verbose --platform iOS UICircularProgressRing

CLEANFILES += $(UICIRCULARPROGRESSRING_TARBALLS) $(UICIRCULARPROGRESSRING_BUILT_PRODUCTS)

# ======== PopupDialog ===========

POPUPDIALOG_SRCDIR = $(CARTHAGE_SRCDIR)/PopupDialog
POPUPDIALOG_FRAMEWORKS = PopupDialog.framework DynamicBlurView.framework
POPUPDIALOG_FRAMEWORKBUNDLES = $(addprefix $(CARTHAGE_BUILDDIR)/, $(POPUPDIALOG_FRAMEWORKS))
POPUPDIALOG_TARBALLS = $(addsuffix .tar.bz2, $(POPUPDIALOG_FRAMEWORKS))
POPUPDIALOG_BUILT_PRODUCTS = $(addprefix $(BUILT_PRODUCTS_DIR)/, $(POPUPDIALOG_FRAMEWORKS))

$(POPUPDIALOG_FRAMEWORKS) : $(POPUPDIALOG_SRCDIR) $(POPUPDIALOG_FRAMEWORKBUNDLES) $(POPUPDIALOG_TARBALLS) $(POPUPDIALOG_BUILT_PRODUCTS)

$(POPUPDIALOG_SRCDIR) :
	carthage checkout PopupDialog

$(POPUPDIALOG_FRAMEWORKBUNDLES) :
	carthage build --verbose --platform iOS PopupDialog

CLEANFILES += $(POPUPDIALOG_TARBALLS) $(POPUPDIALOG_BUILT_PRODUCTS)

# ======= Common recipes ===========
#
%.tar.bz2 : $(CARTHAGE_BUILDDIR)/%
	tar -C $(<D) -cjf $@ $(<F) || $(RM) $@

$(BUILT_PRODUCTS_DIR)/% : %.tar.bz2
	mkdir -p $(@D)
	tar -C $(@D) -xmf $<

clean:
	$(RM) -r Carthage
	$(RM) -r $(CLEANFILES)
	$(RM) -r build
