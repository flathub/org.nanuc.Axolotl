
FLATPAK=$(shell which flatpak)
FLATPAK_BUILDER=$(shell which flatpak-builder)

FLATPAK_MANIFEST=org.nanuc.Axolotl.yml
FLATPAK_BUILD_FLAGS=--verbose --force-clean

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

.PHONY: build-electron-bundle
build-electron-bundle:
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) --stop-at=metadata $(FLATPAK_MANIFEST)

.PHONY: debug
debug:
	$(FLATPAK_BUILDER) --run --verbose build $(FLATPAK_MANIFEST) sh
