# Hemingway editor style Vale rules

A Vale style that checks sentence length, passive voice, adverbs, and word choice.
Use the alerts to guide edits. Keep a phrase if it serves your text.

## Requirements

Use Vale 3.20+ for the `Std` package.
Run `vale sync` to fetch `Std` and `Readability`.

## Checks

| Check                 | Rule                         | Limit or source                 |
| --------------------- | ---------------------------- | ------------------------------- |
| Long sentence         | `Hemingway.LongSentence`     | Over 20 words                   |
| Hard-to-read sentence | `Hemingway.VeryLongSentence` | Over 30 words                   |
| Adverbs               | `Hemingway.Adverbs`          | Part-of-speech tag `RB`         |
| Passive voice         | `Hemingway.PassiveVoice`     | Uses `Std.Grammar.PassiveVoice` |
| Word choice           | `Hemingway.SimplerWords`     | Suggests plain words            |
| Reading grade         | `Readability.FleschKincaid`  | Below grade 8                   |

## Install

Add the release URL to your project's `.vale.ini`:

```ini
StylesPath = styles
Packages = https://github.com/eiri/vale-hemingway/releases/latest/download/Hemingway.zip
```

If your file has a `Packages` list, append the URL with a comma.
Run:

```sh
vale sync
vale .
```

The package fetches `Std` and `Readability` and turns on `Vale`, `Hemingway`, and `Readability`.
It checks files with these types: `.md`, `.txt`, `.rst`, and `.adoc`.
You can use it without a local copy of the rules or a `BasedOnStyles` entry.

To pin a release, replace `latest/download` with `download/v0.1.0`.
Use a tag that exists. The URL needs a release to work.

## Tune

Set the word limit in `.vale.ini`:

```ini
Hemingway.LongSentence[max] = 22
```

You can change `max` in a child rule:

```yaml
max: 20
```

## Build and release

Build the package with:

```sh
sh scripts/package.sh
```

The script creates `dist/Hemingway.zip`.
The ZIP holds `.vale.ini` and `styles/Hemingway/` in a root folder named `Hemingway`.
Vale fetches `Std` and `Readability` on sync.

### Local test

With Vale, `zip`, and `jq` on your path, test the package in an empty project:

```sh
sh scripts/test.sh
```

The test uses a temp folder and needs network access to fetch the two styles.
To publish, push a version tag such as `v1.0.0`.
The release workflow builds the ZIP and adds it to a GitHub release.

## License

[MIT](LICENSE)
