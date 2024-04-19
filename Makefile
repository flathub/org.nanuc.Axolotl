FLATPAK := $(shell which flatpak)
FLATPAK_BUILDER := $(shell which flatpak-builder)
PYTHON := $(shell which python3)
FLATPAK_NODE_GENERATOR := $(shell which flatpak-node-generator)

FLATPAK_MANIFEST=org.nanuc.Axolotl.yml
FLATPAK_APPID=org.nanuc.Axolotl

FLATPAK_BUILD_FLAGS := --verbose --force-clean --install-deps-from=flathub --ccache
FLATPAK_INSTALL_FLAGS := --verbose --force-clean --ccache --user --install
FLATPAK_DEBUG_FLAGS := --verbose --run

all: build

.PHONY: build-dependencies
build-dependencies:
	$(FLATPAK) install org.freedesktop.Sdk.Extension.node16//21.08
	$(FLATPAK) install org.freedesktop.Sdk.Extension.rust-stable//21.08
	$(FLATPAK) install org.gnome.Platform//45
	$(FLATPAK) install org.gnome.Sdk//45

.PHONY: build
build:
	@echo "Building flatpak..."
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: debug
debug:
	$(FLATPAK_BUILDER) $(FLATPAK_DEBUG_FLAGS) build $(FLATPAK_MANIFEST) sh

.PHONY: debug-installed
debug-installed:
	$(FLATPAK) run --command=sh --devel $(FLATPAK_APPID)

.PHONY: install
install:
	@echo "Installing flatpak..."
	$(FLATPAK_BUILDER) build $(FLATPAK_INSTALL_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: uninstall
uninstall:
	$(FLATPAK) uninstall --delete-data --assumeyes $(FLATPAK_APPID)

.PHONY: run
run:
	$(FLATPAK) run $(FLATPAK_APPID)

.PHONY: update-submodules
update-submodules:
	git submodule foreach git pull

.PHONY: install-flatpak-node-generator
install-flatpak-node-generator:
	pipx install --force ./flatpak-builder-tools/node

.PHONY: generate-axolotl-node-sources
generate-axolotl-node-sources:
	@echo "Generating node sources..."
	$(FLATPAK_NODE_GENERATOR) yarn ../axolotl/axolotl-web/yarn.lock \
        --recursive \
        --split \
        --output node-sources.json

.PHONY: generate-axolotl-cargo-sources
generate-axolotl-cargo-sources:
	@echo "Generating cargo sources..."
	$(PYTHON) flatpak-builder-tools/cargo/flatpak-cargo-generator.py \
        ../axolotl/Cargo.lock \
        --output cargo-sources.json

.PHONY: generate-axolotl-sources
generate-axolotl-sources: generate-axolotl-node-sources generate-axolotl-cargo-sources
