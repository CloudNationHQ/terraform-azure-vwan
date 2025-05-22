# Changelog

## [4.4.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v4.3.0...v4.4.0) (2025-05-22)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#101](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/101)) ([5dd1350](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/5dd13501b379d76e1e1010bb4210f0f5e3eb3b37))

## [4.3.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v4.2.0...v4.3.0) (2025-05-01)


### Features

* **deps:** bump golang.org/x/net from 0.36.0 to 0.38.0 in /tests ([#96](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/96)) ([2128743](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/2128743d33be2570d16157945b0a3a7b56b981f3))


### Bug Fixes

* remove non existing gateway_ip vpn sites in type definition ([#99](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/99)) ([724cd7e](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/724cd7efa24cb311509a499bba8f57f9077404f0))

## [4.2.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v4.1.0...v4.2.0) (2025-04-14)


### Features

* add type definitions ([#94](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/94)) ([ccd49de](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/ccd49de9b6ac42696b34bd0573e7760001007e2b))
* **deps:** bump golang.org/x/net from 0.34.0 to 0.36.0 in /tests ([#91](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/91)) ([ab70a0a](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/ab70a0a9eaf1e98ca78a4804ef22831ec62b7c86))

## [4.1.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v4.0.0...v4.1.0) (2025-03-11)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#85](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/85)) ([37cd714](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/37cd714cdf667aca1c039ec86a851eff16e070c3))


### Bug Fixes

* fix typo routing intent module reference ([#88](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/88)) ([1d08b5d](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/1d08b5de0f51040efb061252b99849634f5d5254))

## [4.0.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.5.0...v4.0.0) (2025-03-11)


### ⚠ BREAKING CHANGES

* They key in vpn site links has changed. This change will cause a recreate on existing resources. Also the vhub connection submodule now supports multiple connections within a single configuration. This will also cause a recreate and change in the data structure. See the examples as a reference

### Features

* add missing properties and functionality ([#86](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/86)) ([9710ca6](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/9710ca63a12c14a886cbcedaaacff1fd8c393195))

## [3.5.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.4.1...v3.5.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#78](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/78)) ([f78dbde](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/f78dbdea92b63a93ec4d7609bcb357f62caa7b8e))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#82](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/82)) ([ea740a8](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/ea740a8e9c3ea74bdaa10a365fd9d60a3f602ec4))
* remove temporary files when deployment tests fails ([#80](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/80)) ([e0a872a](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/e0a872a1648c05f514464b82bbde804cf503d62b))

## [3.4.1](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.4.0...v3.4.1) (2024-11-13)


### Bug Fixes

* fix submodule documentation generation ([#75](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/75)) ([186c8ab](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/186c8ab0d2b6083af6922372e8811cc8e7b5b81a))

## [3.4.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.3.0...v3.4.0) (2024-11-13)


### Features

* add vhub-connection submodule including example ([#73](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/73)) ([dc40769](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/dc40769d583f3cd8c9f79237b01e04e9036cced5))

## [3.3.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.2.0...v3.3.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#71](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/71)) ([4a5463e](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/4a5463e54d67ad93f1f37267a6544c9c64f3cafd))

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.1.0...v3.2.0) (2024-10-31)


### Features

* add express route gateway support ([#69](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/69)) ([4c3ebaf](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/4c3ebaf10ca7ccdd6ff1e7998a4d214aa4e16b95))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v3.0.0...v3.1.0) (2024-10-28)


### Features

* add virtual hub security partner provider support ([#66](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/66)) ([dc0dcb6](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/dc0dcb6890140d59153598ba7a23cc03a3f4b5a8))
* add vpn gateway nat rules support ([#68](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/68)) ([270b549](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/270b549f03103f3aef5647d9a7bcae93b6650cd1))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v2.1.0...v3.0.0) (2024-10-28)


### ⚠ BREAKING CHANGES

* the data structure has been updated to reflect changes in vpn functionality

### Features

* add point to site vpn support ([#64](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/64)) ([88190e6](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/88190e611a1870672c5f678a6693c5a802f31dd6))

### Upgrade from v2.1.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- Rename properties in vwan object:
  - within virtual hubs, vpn_gateway has been renamed to site_to_site_vpn to accommodate the option of utilizing point_to_site_vpn as well


## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v2.0.1...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#62](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/62)) ([0011e7d](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/0011e7d1eed02c3f70256b5b19626e1f06d4f46c))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#56](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/56)) ([dbc5f53](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/dbc5f5308b90838334c530b986f3b0e892764417))

## [2.0.1](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v2.0.0...v2.0.1) (2024-09-25)


### Bug Fixes

* fix global tags and updated documentation ([#54](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/54)) ([8da21d7](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/8da21d7ccc221be21981610b186137c384a217db))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v1.1.0...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#52](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/52)) ([c1eadc6](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/c1eadc61c67735b38f5bc2140259f7b0db6af7c6))

### Upgrade from v1.1.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v1.0.0...v1.1.0) (2024-09-19)


### Features

* add support for vpn gateways, sites and connections ([#50](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/50)) ([0b6266e](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/0b6266e70fca1a7e274b2efc84b817b5cca561a8))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.12.0...v1.0.0) (2024-09-18)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties and removal of resources.

### Features

* aligned several properties and resources ([#47](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/47)) ([f155777](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/f1557774ee77f369689b86dff4818ab3a639b46d))

### Upgrade from v0.12.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Rename property in cluster object:
  - resourcegroup -> resource_group
- Rename variable (optional):
  - resourcegroup -> resource_group
- Rename output variable:
  - vhub -> vhubs
- Removed output variables:
  - policy
  - firewall_public_ip_addresses
  - firewall
- Removed resources:
  - azurerm_ip_group
  - azurerm_firewall_policy_rule_collection_group
  - azurerm_firewall_policy

## [0.12.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.11.0...v0.12.0) (2024-08-29)


### Features

* update documentation ([#43](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/43)) ([16932cb](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/16932cb5899e723205ca5b05950f9b94976728d4))

## [0.11.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.10.0...v0.11.0) (2024-08-29)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#42](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/42)) ([5c45050](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/5c450502d04698c33117208de17f87821cc4d231))
* update contribution docs ([#40](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/40)) ([4e96312](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/4e96312c73dac1b354be0eaaa2ddf0057e3c0e94))

## [0.10.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.9.0...v0.10.0) (2024-07-02)


### Features

* add issue template ([#38](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/38)) ([63737f3](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/63737f3ebb2b3f33ba73b15b89728f2ba0c609e1))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#37](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/37)) ([50e2126](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/50e21269814b5415777750e86df4b536bc9b0f9b))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#36](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/36)) ([c4659b4](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/c4659b46fba730b13440e7d07f73aade145e193f))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.8.0...v0.9.0) (2024-06-08)


### Features

* create pull request template ([#34](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/34)) ([9bbff05](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/9bbff05b91bdc856e65a1fd755a65f36903f2c6a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#33](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/33)) ([3823a58](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/3823a58fe1b3318d30e2d83c4c2dc46371d79959))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#31](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/31)) ([31588fd](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/31588fd90357bcca5c9731cc62dcd4793614f102))
* **deps:** bump golang.org/x/net from 0.17.0 to 0.23.0 in /tests ([#30](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/30)) ([56cee6b](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/56cee6b4a632d3243a9cf144aca7a8fcb151336d))
* **deps:** bump google.golang.org/protobuf in /tests ([#28](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/28)) ([f3332b0](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/f3332b090c9e0106b351f58fbd4328f762b151c2))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.7.0...v0.8.0) (2024-02-28)


### Features

* improve conditional expression threat intelligence allowlist block ([#26](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/26)) ([53b5cc2](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/53b5cc215e1e88b82af8a2a46f34c5da6a6f8fb9))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.6.1...v0.7.0) (2024-02-14)


### Features

* naming variable is now optional and added tags property on several resources ([#24](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/24)) ([bab5a92](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/bab5a925c02494b6fe3a91b0a6363dbe2e59bfc6))

## [0.6.1](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.6.0...v0.6.1) (2024-02-14)


### Bug Fixes

* fix conditional expression rule collection names ([#22](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/22)) ([4adbd1a](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/4adbd1a249a5472c8997a01b88efc86780fa1442))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.5.1...v0.6.0) (2024-02-10)


### Features

* add ip groups submodule and small refactors ([#20](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/20)) ([90fcdca](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/90fcdca57122cbfd03cfb0e07f62becb5513871d))

## [0.5.1](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.5.0...v0.5.1) (2024-02-06)


### Bug Fixes

* fix wrong reference threat intelligence allowlist block ([#18](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/18)) ([eb310d4](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/eb310d4e4a15f7d94d0545775280c672d30cc419))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.4.0...v0.5.0) (2024-02-06)


### Features

* add threat intelligence allow list support on submodule ([#16](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/16)) ([b5200ca](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/b5200ca7a5c00c64c00ca260ca422ee63a3eeacf))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.3.0...v0.4.0) (2024-02-06)


### Features

* change firewall policy dns defaults ([#14](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/14)) ([8b99b6b](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/8b99b6b5df06836356fe6802c8b3d38a23eb01c0))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.2.2...v0.3.0) (2024-02-02)


### Features

* update documentation submodules ([#12](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/12)) ([7a2a289](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/7a2a2895efaa09fa16ec85c90389554454f8f4df))

## [0.2.2](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.2.1...v0.2.2) (2024-01-31)


### Bug Fixes

* fix conditional expression ip groups naming ([#9](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/9)) ([a036fde](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/a036fde5708723129106f2e1c19e6d65cc8c50da))

## [0.2.1](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.2.0...v0.2.1) (2024-01-31)


### Bug Fixes

* add missing providers block submodules ([#7](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/7)) ([2f8b15f](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/2f8b15fe6f0ceaf4377fe3ec4f7c066f0064731f))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-vwan/compare/v0.1.0...v0.2.0) (2024-01-30)


### Features

* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#3](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/3)) ([44149ee](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/44149ee2ed3c77745bb8b3d563a815d9d1487e7b))

## 0.1.0 (2024-01-30)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/2)) ([27f7932](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/27f7932299d66bf77f90b4f8da350ac8de2c8e9a))
* add workflows ([#4](https://github.com/CloudNationHQ/terraform-azure-vwan/issues/4)) ([5bc9418](https://github.com/CloudNationHQ/terraform-azure-vwan/commit/5bc9418f90f794d8779e7c47a5e2fd9eb1bb3952))
