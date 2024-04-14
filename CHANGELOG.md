## [0.2.0] - 2024-04-14

- `Bitary#to_a` now returns a clone to prevent client code to misuse the data structure (same for `Bitary#each_byte`)
- Streamline the internal array initialization
- Enhance constructor implementation
- `Bitary#set` and `Bitary#set` are now suffixed by `!`

## [0.1.9] - 2024-04-01

- boost perf even more by inlining mapping operations

## [0.1.8] - 2024-04-01

- inline bit operations to regain original perf

## [0.1.7] - 2024-04-01

- loads of refactoring and perf improvements
- Bitary now acts as the logical layer, whereas Bitwarr acts as the business layer

## [0.1.6] - 2024-03-31

- enhance global perf by remove useless and heavy error handling

## [0.1.5] - 2024-03-31

- enhance performance of #each_byte (4 seconds faster on average)

## [0.1.4] - 2024-03-31

- more refactoring of Bitary class
- fix issue in getting/setting bits when size is not % 8 

## [0.1.3] - 2024-03-29

- fix some missing require statements
- further refactoring of Bitary class

## [0.1.2] - 2024-03-29

- internal refactoring of the Bitary class
- addition of integer size enum

## [0.1.1] - 2024-03-26

- Change root namespace to a class, instead of a module

## [0.1.0] - 2024-03-26

- Initial release
- Basic implementation to set/unset/get bits from the bit array
- Ability to traverse each byte of the structure
- Increase/decrease the number of bits used internally per element
