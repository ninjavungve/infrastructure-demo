provider "aws" {
	version = "~> 1.0"
	profile = "zargony"
	# Use `aws --profile zargony configure` to enter AWS keys
	#access_key = "..."
	#secret_key = "..."
	region = "${var.region}"
}

resource "aws_key_pair" "lina" {
	key_name = "zargony@lina"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSt+5Ennalg+GM7+0/37ukXuYR523DEWHTygpuGH1CI3GG0vMKHquG2lUEOKJ2mh4Pt5OBXxNfKxl3mmaPxyUStcMBwS25AQQhyLkFGp2sRFKpZQrEYozJ1galkPwdG4OsdtZXDdeDodsttDjIKchPPOSh0bHoXvIkA+zzWBu9wxZKc4EhQHN2+cI268NT+mZYFCFLcL2Zpr+eBW1OvnQ5MdG9kh4jYBc2kORXR4CzzCEVnkoibLLM7cczV96jugouVGTpDIYValBERWOM2aUFEbyRo3vAlveAfoFrYWFmvOgT2ynq1wHG6AcbsOOeAeCLO8slimmmgExhxtTEOGzQ== zargony@lina"
}

resource "aws_key_pair" "priya" {
	key_name = "zargony@priya"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwFQFH9XgcgJ2l43yr69sAkql39VKOCVSMfv6jH/ml0WyD0FP2GO1mMoW/teCuRbWqWxXr7fF0QhOi60g1e4xE766Rkll9xBmx+ckPuSj3xmKOUpnn/Z/rjFzwAQ452lJtIGySSNUbfxM00usDF0+kc5wMR1ugnR3S3y2loVN38RzVgUVMm7r1qhnttsUi/HeXFTw1j7Gaqbmz5PEyMKXeI9fvml1wAzf14JMvxjHSQBBvwLuvAAGMPbdd136bIpY+Vpvc3+zXyODLoFOuyl5cuAHULg0thrpifmgrtkLdD2TpKJqqio2kMrS7A0L5Hg+OXD3qlYPFaMl9tZb0QgBl zargony@priya"
}

module "static" {
	source = "static-website"

	fqdn = "static.zargony.com"
}
