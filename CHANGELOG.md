# Changelog

## [0.2.0] Unreleased

### Changed

- Refactor classes structure and tests.
- Rename the gem to `jsonapi-record`.
- Rename `request_payload` to `to_payload`.
- Rename `attributes_for_request` to `payload_attributes`.
- Rename `relationships_for_request` to `payload_relationships`.

### Removed

- Removed `resource_attribute` method and replaced with just `attribute`.

### Added

- Add `payload_attributes_for_create` method.
- Add `payload_attributes_for_update` method.
- Add a way to override `createable_attribute_names`.
- Add a way to override `updatable_attribute_names`.


## [0.1.3] 2018-06-22

### Removed

- Remove Errors module.

## [0.1.2] 2018-06-21

### Changed

- Update jsonapi-client to version 0.1.2

## [0.1.1] 2018-06-15

### Fixed

- Fix included resources not being parsed correctly [#3](https://github.com/InspireNL/jsonapi-resource/pull/3).

## [0.1.0] 2018-06-12

### Added

- Minimal functionality.
- README
- CHANGELOG
