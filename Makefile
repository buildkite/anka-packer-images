
headless := true
packer_args := -force
output_directory := output
packer_log := 0
build_number ?= 1

validate:
	packer version
	find . -name '*.json' -print0 | xargs -n1 -0 packer validate -syntax-only

clean:
	-rm -rf output/
	-rm -rf installers/

# macOS images
# -------------------------------------------------------------

macos-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var source_vm="$(source_vm)" \
		-var build_number="$(build_number)" \
		macos-10.12.json

macos-xcode-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var source_vm="$(source_vm)" \
		-var build_number="$(build_number)" \
		macos-xcode-10.12.json

macos-buildkite-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var source_vm="$(source_vm)" \
		-var build_number="$(build_number)" \
		macos-buildkite-10.12.json
