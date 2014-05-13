#!/bin/bash
set -e

test -x /usr/bin/curl || apt-get install -qy curl

if ! test -e /etc/apt/sources.list.d/docker.list; then
	# Docker release key from https://get.docker.io/gpg
	apt-key add - <<-EOF
		-----BEGIN PGP PUBLIC KEY BLOCK-----
		Version: GnuPG v1.4.14 (GNU/Linux)

		mQENBFIOqEUBCADsvqwefcPPQArws9jHF1PaqhXxkaXzeE5uHHtefdoRxQdjoGok
		HFmHWtCd9zR7hDpHE7Q4dwJtSFWZAM3zaUtlvRAgvMmfLm08NW9QQn0CP5khjjF1
		cgckhjmzQAzpEHO5jiSwl0ZU8ouJrLDgmbhT6knB1XW5/VmeECqKRyhlEK0zRz1a
		XV+4EVDySlORmFyqlmdIUmiU1/6pKEXyRBBVCHNsbnpZOOzgNhfMz8VE8Hxq7Oh8
		1qFaFXjNGCrNZ6xr/DI+iXlsZ8urlZjke5llm4874N8VPUeFQ/szmsbSqmCnbd15
		LLtrpvpSMeyRG+LoTYvyTG9QtAuewL9EKJPfABEBAAG0OURvY2tlciBSZWxlYXNl
		IFRvb2wgKHJlbGVhc2Vkb2NrZXIpIDxkb2NrZXJAZG90Y2xvdWQuY29tPokBOAQT
		AQIAIgUCUg6oRQIbLwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ2Fdqi6iN
		IenM+QgAnOiozhHDAYGO92SmZjib6PK/1djbrDRMreCT8bnzVpriTOlEtARDXsmX
		njKSFa+HTxHi/aTNo29TmtHDfUupcfmaI2mXbZt1ixXLuwcMv9sJXKoeWwKZnN3i
		9vAM9/yAJz3aq+sTXeG2dDrhZr34B3nPhecNkKQ4v6pnQy43Mr59Fvv5CzKFa9oZ
		IoZf+Ul0F90HSw5WJ1NsDdHGrAaHLZfzqAVrqHzazw7ghe94k460T8ZAaovCaTQV
		HzTcMfJdPz/uTim6J0OergT9njhtdg2ugUj7cPFUTpsxQ1i2S8qDEQPL7kabAZZo
		Pim0BXdjsHVftivqZqfWeVFKMorchQ==
		=fRgo
		-----END PGP PUBLIC KEY BLOCK-----
	EOF
	echo "deb http://get.docker.io/ubuntu docker main" >/etc/apt/sources.list.d/docker.list
	apt-get update -qq
fi

test -e /lib/modules/`uname -r`/kernel/ubuntu/aufs/aufs.ko || apt-get install -qy linux-image-extra-`uname -r`
test -x /usr/bin/auchk || apt-get install -qy aufs-tools
test -x /usr/bin/docker || apt-get install -qy lxc-docker
