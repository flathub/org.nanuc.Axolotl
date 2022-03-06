FLATPAK=$(shell which flatpak)
FLATPAK_BUILDER=$(shell which flatpak-builder)
PYTHON=$(shell which python3)

FLATPAK_MANIFEST=org.nanuc.Axolotl.yml
FLATPAK_APPID=org.nanuc.Axolotl

FLATPAK_BUILD_FLAGS=--verbose --force-clean --install-deps-from=flathub
FLATPAK_INSTALL_FLAGS=--verbose --user --install --force-clean
FLATPAK_DEBUG_FLAGS=--verbose --run

all: build

.PHONY: build-dependencies
build-dependencies:
	$(FLATPAK) install org.freedesktop.Sdk.Extension.golang//21.08
	$(FLATPAK) install org.freedesktop.Sdk.Extension.node16//21.08
	$(FLATPAK) install org.freedesktop.Sdk.Extension.rust-stable//21.08
	$(FLATPAK) install org.freedesktop.Platform//21.08
	$(FLATPAK) install org.freedesktop.Sdk//21.08
	$(FLATPAK) install org.electronjs.Electron2.BaseApp//21.08

.PHONY: build
build:
	@echo "Building flatpak..."
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: build-crayfish
build-crayfish:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=zkgroup $(FLATPAK_MANIFEST)

.PHONY: build-zkgroup
build-zkgroup:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=astilectron-bundler $(FLATPAK_MANIFEST)

.PHONY: build-astilectron-bundler
build-astilectron-bundler:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=axolotl-electron-bundle $(FLATPAK_MANIFEST)

.PHONY: build-astilectron-bundler-resources
build-astilectron-bundler-resources:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=axolotl-electron-bundle $(FLATPAK_MANIFEST)

.PHONY: build-electron-bundle
build-electron-bundle:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=metadata $(FLATPAK_MANIFEST)

.PHONY: build-metadata
build-electron-bundle:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=run $(FLATPAK_MANIFEST)

.PHONY: debug
debug:
	$(FLATPAK_BUILDER) $(FLATPAK_DEBUG_FLAGS) build $(FLATPAK_MANIFEST) sh

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

.PHONY: generate-astilectron-bundler-sources
generate-astilectron-bundler-sources:
	@echo "Generating astilectron-bundler sources..."
	$(FLATPAK_BUILDER) build astilectron-bundler-download-manifest.yml \
		--verbose \
		--keep-build-dirs \
		--force-clean
	$(PYTHON) flatpak-builder-tools/go-get/flatpak-go-get-generator.py .flatpak-builder/build/astilectron-bundler
	mv astilectron-bundler-sources.json generated-astilectron-bundler-sources.json

.PHONY: generate-axolotl-sources
generate-axolotl-sources:
	@echo "Generating axolotl sources..."
	$(FLATPAK_BUILDER) build axolotl-download-manifest.yml \
		--verbose \
		--keep-build-dirs \
		--force-clean
	$(PYTHON) flatpak-builder-tools/go-get/flatpak-go-get-generator.py .flatpak-builder/build/axolotl
	mv axolotl-sources.json generated-axolotl-sources.json

.PHONY: generate-axolotl-web-sources
generate-axolotl-web-sources:
	@echo "Generating axolotl-web sources..."
	$(PYTHON) flatpak-builder-tools/node/flatpak-node-generator.py \
	npm ../axolotl/axolotl-web/package-lock.json \
        --recursive \
        --xdg-layout \
        --split \
        --output generated-axolotl-web-sources.json

.PHONY: generate-zkgroup-sources
generate-zkgroup-sources:
	@echo "Generating zkgroup sources..."
	$(PYTHON) flatpak-builder-tools/cargo/flatpak-cargo-generator.py \
        ../zkgroup/lib/zkgroup/Cargo.lock \
        --output generated-zkgroup-sources.json

.PHONY: generate-crayfish-sources
generate-crayfish-sources:
	@echo "Generating crayfish sources..."
	$(PYTHON) flatpak-builder-tools/cargo/flatpak-cargo-generator.py \
        ../axolotl/crayfish/Cargo.lock \
        --output generated-crayfish-sources.json