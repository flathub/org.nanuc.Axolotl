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
make generate-crayfish-sources
```

```shell
make generate-zkgroup-sources
```

## Go sources

For go, [Flatpak Go Get Generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/go-get/README.md) is
provided.

### axolotl

```shell
make generate-axolotl-sources
```

### astilectron-bundler

```shell
make generate-astilectron-bundler-sources
```