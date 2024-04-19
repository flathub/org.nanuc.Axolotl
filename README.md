# axolotl Flathub

This repo is only for publishing the axolotl cross-platform Signal client to Flathub.

For the full repository, see [GitHub](https://github.com/nanu-c/axolotl).

The following information is mainly interesting for Axolotl Flathub packagers and maintainers.

## Update dependencies

A Flathub release must specify all its build dependencies, and may not use the `--share=network` flag.

Instead, a fixed list of dependencies is used. To generate these, Flathub provides some python scripts.

Before executing the below scripts, make sure to check out the relevant git tag in the axolotl repository at `../axolotl`.

## NPM sources

For NPM, [flatpak-node-generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/node/README.md) is
provided.

```shell
make generate-axolotl-node-sources
```

## Cargo sources

For Cargo, [flatpak-cargo-generator](https://github.com/flatpak/flatpak-builder-tools/blob/master/cargo/README.md) is
provided.

```shell
make generate-axolotl-cargo-sources
```
