# Changelog (Marathon)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2021-0X-XX
### Added
- Two remove methods, one for the client-side and another for the server-side.

### Changed
- Middleware now adds multiple headers instead of folding all the cookies into one header.
- Project is now using null-safety.
- Improved clarity of dartdocs.

### Removed
- The original remove method.

___

Below is the changelog kept by Izolate before the forking point. See README.md
for more details.

---

# Changelog (Izolate)
## [1.1.1] - 2019-08-12
### Changed
- Used cookie parsing function from dart:io

## [1.1.0] - 2019-08-12
### Added
- Ability to set cookie attributes (Secure, HttpOnly, etc.)
- Method to clear all cookies in list

## [1.0.2] - 2019-08-11
### Fixed
- Set multiple cookies correctly

## [1.0.1] - 2019-08-11
### Added
- Changelog
- Examples

## [1.0.0] - 2019-08-11
### Added
- Cookie parser
- Cookie parser middleware
