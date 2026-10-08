# homebrew-tap

David Awad's personal Homebrew tap.

```bash
brew tap davidawad/tap
brew install davidawad/tap/<formula>
```

## Formulae

| Formula | What it does | Install | Platforms |
| ------- | ------------ | ------- | --------- |
| [`biomarker-cli`](https://github.com/davidawad/biomarker-cli) | Track lab results (biomarkers) for any number of people; CSV/JSON/YAML/TOON in and out; encrypted at rest with your SSH key. | `brew install davidawad/tap/biomarker-cli` | macOS arm64/x86_64, Linux arm64/x86_64 (prebuilt); Windows: zip from the [releases](https://github.com/davidawad/biomarker-cli/releases) |
| [`genome-cli`](https://github.com/davidawad/genome-cli) | Personal genomic data: 23andMe/Ancestry array exports, whole-genome VCF and FASTQ; lookups, build liftover, kit comparison; encrypted at rest. | `brew install davidawad/tap/genome-cli` | macOS arm64/x86_64, Linux arm64/x86_64 (prebuilt); Windows: zip from the [releases](https://github.com/davidawad/genome-cli/releases) |
| [`docdiff`](https://github.com/davidawad/docdiff) | Git-diff style plaintext compare for Word and other legal documents. | `brew install davidawad/tap/docdiff` | macOS, Linux (built from source) |
| [`litgraph`](https://github.com/davidawad/litgraph) | Litigation procedure graph engine (CLI + MCP server), JSON in/out. | `brew install davidawad/tap/litgraph` | macOS arm64/x86_64, Linux x86_64 (prebuilt) |
| [`easel`](https://github.com/davidawad/eas.el) | Interactive, agent-drivable charts from declarative JSON, pure Emacs Lisp; installs the library, templates and an `eas` CLI. | `brew install davidawad/tap/easel` | macOS, Linux (built from source tarball) |
| [`financial-charts`](https://github.com/davidawad/financial-charts.el) | Financial charts in Emacs (`financial-chart`): text in a terminal, SVG in a GUI. HEAD-only for now. | `brew install --HEAD davidawad/tap/financial-charts` | macOS, Linux |

`easel` (eas.el) and `financial-charts` are Emacs packages: they install into `share/emacs/site-lisp/` and print the `load-path` line for your `init.el` in their caveats. `financial-charts` is HEAD-only (`brew install --HEAD`) until a tagged release exists.

`genome-cli`'s FASTQ-to-VCF pipeline also needs `brew install minimap2 samtools bcftools`.

## Related Emacs packages

These read the CLIs above and are installed from their repositories (not Homebrew):

| Package | What it does |
| ------- | ------------ |
| [health-charts.el](https://github.com/davidawad/health-charts.el) | Charts and Org health reports over `biomarker-cli` data (Vega-Lite or gnuplot). |
| [genetics.el](https://github.com/davidawad/genetics.el) | Browse and annotate consumer genetics exports and VCFs, backed by `genome-cli`. |
| [fastq-mode](https://github.com/davidawad/fastq-mode) | Streaming major mode for `.fastq`/`.fastq.gz` reads: base and quality colouring, per-base Phred at point, stats, mate jump. |
