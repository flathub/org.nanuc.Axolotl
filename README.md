# axolotl Flathub

This repo is only for publishing the axolotl cross-platform Signal client to Flathub.

For the full repository, see [GitHub](https://github.com/nanu-c/axolotl).

The following information is mainly interesting for Axolotl Flathub packagers and maintainers.

## Update dependencies

A Flathub release must specify all its build dependencies, and may not use the `--share=network` flag.

Instead, a fixed list of dependencies is used. To generate these, Flathub provides some python scripts.

## NPM sources

For NPM, [flatpak-node-generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/node/README.md) is
provided.

The current version of "@vue/cli-service" dependency has a problematic "vue-loader-v15" dependency
which the node-generator script does not handle well when using NPM. Solution: we generate the lock file with yarn.

```shell
yarn install --cwd ../axolotl/axolotl-web
```

Using this as listed below gives us a list of dependencies.

```shell
python3 flatpak-builder-tools/node/flatpak-node-generator.py \
    yarn ../axolotl/axolotl-web/yarn.lock \
    --recursive \
    --xdg-layout \
    --split \
    --output generated-axolotl-web-sources.json
```

## Cargo sources

For Cargo, [flatpak-cargo-generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/cargo/README.md) is
provided.

```shell
python3 flatpak-builder-tools/cargo/flatpak-cargo-generator.py \
    ../axolotl/crayfish/Cargo.lock \
    --output generated-crayfish-sources.json
```

```shell
python3 flatpak-builder-tools/cargo/flatpak-cargo-generator.py \
    ../zkgroup/lib/zkgroup/Cargo.lock \
    --output generated-zkgroup-sources.json
```

## Go sources

For go, [Flatpak Go Get Generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/go-get/README.md) is
provided.

### axolotl

```shell
flatpak-builder build axolotl-download-manifest.yml --verbose --keep-build-dirs --force-clean
```

```shell
python3 flatpak-builder-tools/go-get/flatpak-go-get-generator.py .flatpak-builder/build/axolotl
```

```shell
mv axolotl-sources.json generated-axolotl-sources.json
```

### astilectron-bundler

```shell
flatpak-builder build astilectron-bundler-download-manifest.yml --verbose --keep-build-dirs --force-clean
```

```shell
python3 flatpak-builder-tools/go-get/flatpak-go-get-generator.py .flatpak-builder/build/astilectron-bundler/
```

```shell
mv astilectron-bundler-sources.json generated-astilectron-bundler-sources.json
```