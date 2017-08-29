
packer_args := -force
output_directory := output
build_number ?= 1
xcode_version = 8.3.2

validate:
	packer version
	find . -name '*.json' -print0 | xargs -n1 -0 packer validate -syntax-only

clean:
	-rm -rf output/
	-rm -rf installers/

delete-all:
	anka list | tail -n+5 | awk '/^\|/ {print $$2}' | xargs -n1 anka delete --yes

setup:
	gem install xcode-install
	mkdir -p .xcodeinstall/
	xcversion install --no-install --verbose $(xcode_version)
	cp $(HOME)/Library/Caches/XcodeInstall/Xcode$(xcode_version).xip .xcodeinstall/

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
