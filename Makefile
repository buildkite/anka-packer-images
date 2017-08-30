
packer_args := -force
output_directory := output

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
		-var vm_name="$(vm_name)" \
		macos-10.12.json

macos-xcode-10.12: 
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var source_vm="$(source_vm)" \
		-var xcode_version="$(xcode_version)" \
		-var build_number="$(build_number)" \
		macos-xcode-10.12.json
