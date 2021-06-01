# axolotl FlatHub

This repo is only for publishing the axolotl cross-platform Signal client to FlatHub.

For the full repository, see [GitHub](https://github.com/nanu-c/axolotl).

## FlatHub golang dependencies

A FlatHub release must specify all its build dependencies, and may not use the `--share=network` flag.

To generate the list of dependencies used, the following mini-manifest can be used.

To use this mini-manifest just store it in a file and use the following command. 

```shell
flatpak-builder build mini-manifest.yml --keep-build-dirs --force-clean
```

```yaml
app-id: org.nanuc.Axolotl
runtime: org.freedesktop.Platform
runtime-version: '20.08'
sdk: org.freedesktop.Sdk
command: axolotl

modules:
  - name: axolotl
    buildsystem: simple
    build-options:
      prefix: /usr/lib/sdk/golang
      prepend-path: /usr/lib/sdk/golang/bin
      build-args:
        - --share=network
    build-commands:
      - "go env -w GOPATH=$PWD; go get -v github.com/nanu-c/axolotl"
```

The resulting build folder is then given as an input to the [Flatpak Go Get Generator](https://github.com/flatpak/flatpak-builder-tools/tree/master/go-get).

```shell
./flatpak-go-get-generator.py ../../org.nanuc.Axolotl/.flatpak-builder/build/axolotl-4
```

Convert to yaml and add to the Axolotl manifest file, to the axolotl section.

```shell
cat axolotl-4-sources.json | yq --yaml-output
```
