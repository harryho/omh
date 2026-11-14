# Stack policy — `dotnet`

**Applies to:** .NET desktop applications — .NET Framework → modern .NET, WinForms or WPF.

Selected with `stack.policy: dotnet` in `omh.config.yaml`. The eight section headings below are
the contract from [`../README.md`](../README.md); `check.sh` asserts they are all present.

## 1. Source and build units

| Kind | What counts | Where |
|---|---|---|
| Source unit | one `.cs` file | `**/*.cs` |
| Resource unit | one `.resx` / `.resources` / `.config` file | `**/*.resx`, `**/*.config` |
| Project unit | one `.csproj` | `**/*.csproj` |
| Built unit | one **managed assembly** (`.dll`) plus the apphost (`.exe`) | publish output |
| Native unit | one native `.dll` | `runtimes/<rid>/native/`, `x64/`, `x86/` |

Baseline census (P0) records: tracked-file count, `.cs` count, `.csproj` count, the
project-reference graph edge count, and the **baseline assembly set** — the list of `.dll` names
in a baseline publish output. That last one is the comparison set for slot 3.

Mixed target frameworks in one solution are normal and must be counted per project, not
assumed.

## 2. Carrying mechanisms

How a runtime input reaches the shipped output:

| Mechanism | Use it for | Note |
|---|---|---|
| `<Content Include=… CopyToOutputDirectory="PreserveNewest">` | data trees, config, fonts, images | SDK-style projects |
| `<None Include=… CopyToOutputDirectory=…>` | files that ship but are not compiled | pre-SDK projects |
| `<EmbeddedResource>` | resources compiled *into* the assembly | invisible in the output tree — decide deliberately |
| Satellite assembly (`<SatelliteResource>`) | localized resources | lands in a `fr/`-style subfolder, **not** at the root |
| `CopyToPublishDirectory` | content needed only in the published output | publish-only |
| `<Content Include="native\**">` + `runtimes/<rid>/native/` | native interop DLLs | RID-specific placement |
| `app.config` → `app.<exe>.config` | runtime configuration | renamed at build; check the **transformed** file |
| `appsettings*.json` copied to output | configuration | |

A contract row with no mechanism here is a census defect — the row must name which of the above
carries it.

## 3. Built-unit list

The set that must match between baseline and upgrade: **the managed assembly set of the publish
output**.

- List: every `*.dll` at the publish root, **excluding** the `ref/` folder and excluding
  satellite subfolders (they are listed separately as locale units).
- Plus the apphost executable name.
- Locale units: the set of satellite-assembly subfolders (`fr/`, `de/`, …) — a locale that
  disappears is a parity loss even though the assembly count is unchanged.

Compare against the baseline assembly set from slot 1. A missing assembly is E1; an extra one is
a footprint question, not automatically a failure.

## 4. Shipped output form

`dotnet publish` produces a directory, not a single file:

```
artifacts/publish/
  app.exe            ← apphost (self-contained or framework-dependent)
  app.dll            ← the managed entry assembly
  *.dll              ← managed dependencies
  *.json             ← deps.json, runtimeconfig.json, appsettings.json
  runtimes/<rid>/    ← RID-specific native assets
  <locale>/          ← satellite assemblies
```

Record which shape the project uses, because it changes the rules:

| Publish mode | Artifact | Side-car rule |
|---|---|---|
| framework-dependent | `app.dll` + `app.exe` apphost + deps | runtime supplied by the host |
| self-contained | apphost + the whole runtime | runtime is **inside** the output |
| `PublishSingleFile` | one `.exe` | side-cars must be `IncludeNativeLibrariesForSelfExtract` or external |
| `PublishTrimmed` | trimmed output | trimming can remove reflective types — a parity hazard |

## 5. Side-car inputs

Inputs that travel beside the program rather than inside it:

- native `.dll` files loaded by `DllImport` / P-Invoke — **must be present in the publish output**;
  the most common parity loss in a .NET Framework → modern .NET move
- satellite assemblies for non-neutral cultures
- `*.resources` side files when not embedded
- data trees the app reads at startup (CSV, JSON, SQLite databases, price/tick archives)
- fonts and images loaded from disk by path
- `app.config`-derived files (`*.exe.config`)

## 6. Build and ship commands

| Purpose | Command |
|---|---|
| Restore (SDK-style) | `dotnet restore` |
| Restore (legacy) | `nuget restore` |
| Build | `dotnet build -c Release` |
| Publish | `dotnet publish -c Release -r <rid> --self-contained <bool> -o artifacts/publish` |
| Assembly list | list `*.dll` at the publish root, excluding `ref/` and satellite folders |
| Locale list | list satellite subfolders of the publish root |
| Diff vs baseline | `git diff --name-only <base>..<branch>` and `git diff --numstat` |

The publish command is a **declared** command: it goes in the plan verbatim, and the footprint
audit (P5a) runs exactly that command. Do not substitute a different publish mode at audit time.

## 7. Smoke launch

| Shape | Launch |
|---|---|
| framework-dependent | `dotnet artifacts/publish/app.dll` |
| self-contained / apphost | `artifacts/publish/app.exe` |
| Single-file | `artifacts/publish/app.exe` |

Evidence to record: the process starts, the main window title appears (or the headless
equivalent logs its banner), no first-run crash, and the process exits or idles as expected.

## 8. Upgrade hazards

What to check for when a .NET Framework app moves to modern .NET — each is a parity risk the
census must cover:

| Hazard | What breaks | Check |
|---|---|---|
| `packages.config` → PackageReference | transitive versions shift | resolved-version diff vs the baseline |
| `<assemblyBinding>` binding redirects | obsolete on modern .NET; assembly unification changes which version loads | inventory every redirect, prove the loaded version |
| `System.Configuration` / `ConfigurationManager` | config source and precedence differ (`app.config` vs `appsettings.json`) | read the same keys in both, compare values |
| `System.Drawing` | Windows-only on modern .NET | inventory every use |
| `System.Web`, `AppDomain`, remoting, CodeDom | removed | grep the source, record each hit as `dead-in-source` or port |
| `WinForms` designer files (`*.Designer.cs`) | designer/runtime divergence; `resx` resources lost | build the designer output and compare resources |
| `app.manifest`, DPI awareness, 32/64-bit | launch failures, blurry UI | record the manifest and the bitness |
| COM interop and `DllImport` | the native DLL must ship in the publish output | confirm each native dependency in the output |
| `PublicKeyToken` / strong naming | assembly identity changes break binding | record signed vs unsigned |
| Mixed target frameworks | one project left on the old TFM silently keeps old behaviour | list each project's TFM |
| `PublishTrimmed` | reflection-dependent code fails at runtime only | probe every reflective path |
| `Nullable` / implicit usings | new .NET SDK defaults change overload resolution | build with the project's declared settings, not the SDK's newest |

Record each hazard you check in the census with its disposition — a hazard not checked is a
parity assumption, and parity assumptions are what this harness exists to eliminate.
