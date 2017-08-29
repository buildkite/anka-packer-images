
packer_args := -force
output_directory := output
build_number ?= 1
source_vm ?= macos-10.12
xcode_version = 8.3.2
xcode_xip = .xcodeinstall/Xcode$(xcode_version).xip
xcode_source_xip = $(HOME)/Library/Caches/XcodeInstall/Xcode$(xcode_version).xip

validate:
	packer version
	find . -name '*.json' -print0 | xargs -n1 -0 packer validate -syntax-only

clean:
	-rm -rf output/
	-rm -rf installers/

delete-all:
	anka list | tail -n+5 | awk '/^\|/ {print $$2}' | xargs -n1 anka delete --yes

$(xcode_source_xip):
	which xcversion || gem install xcode-install
	mkdir -p .xcodeinstall/
	xcversion install --no-install --verbose $(xcode_version)

$(xcode_xip): $(xcode_source_xip)
	cp $(xcode_source_xip) $(xcode_xip)

# macOS images
# -------------------------------------------------------------

macos-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var build_number="$(build_number)" \
		macos-10.12.json

macos-xcode-10.12: $(xcode_xip)
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var source_vm="$(source_vm)" \
		-var build_number="$(build_number)" \
		macos-xcode-10.12.json
