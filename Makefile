
packer_args := -force
output_directory := output
xcode_version := 8.3.3
packer_log := 0

validate:
	packer version
	find . -name '*.json' -print0 | xargs -n1 -0 packer validate -syntax-only

clean:
	-rm -rf output/
	-rm -rf installers/

delete-all:
	anka list | tail -n+5 | awk '/^\|/ {print $$2}' | xargs -n1 anka delete --yes

# macOS images
# -------------------------------------------------------------

macos-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var vm_name="macos-base-10.12" \
		macos-10.12.json

macos-xcode-10.12:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var vm_name="macos-10.12-xcode-$(xcode_version)" \
		-var source_vm="macos-base-10.12" \
		-var xcode_version="$(xcode_version)" \
		macos-xcode-10.12.json
