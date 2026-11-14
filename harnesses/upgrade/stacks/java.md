# Stack policy — `java`

**Applies to:** Java desktop applications — JDK upgrade, Swing/AWT, Maven or Gradle builds.

Selected with `stack.policy: java` in `omh.config.yaml`. The eight section headings below are
the contract from [`../README.md`](../README.md); `check.sh` asserts they are all present.

## 1. Source and build units

| Kind | What counts | Where |
|---|---|---|
| Source unit | one `.java` (or `.kt`) file | `src/main/java/**` |
| Resource unit | one file under the resource root | `src/main/resources/**` |
| Build descriptor | one `pom.xml` or `build.gradle[.kts]` | repo root |
| Module unit | one JPMS module (`module-info.java`) | `src/main/java/**/module-info.java` |
| Built unit | one compiled class tree, or one jar | `target/classes`, `target/*.jar` |

Baseline census (P0) records: tracked-file count, `.java` count, module count, resolved
dependency count (from the lockfile or the dependency-resolution goal), and the **baseline
built-unit set** — the class or jar listing used for slot 3.

Record the build tool and the JDK version the baseline was built with; both change the unit list.

## 2. Carrying mechanisms

How a runtime input reaches the shipped output:

| Mechanism | Use it for | Note |
|---|---|---|
| `src/main/resources` | the default resource root | copied verbatim into the jar |
| Maven `<resources>` | custom resource roots, filtering | `<filtering>` rewrites content — a parity risk |
| Gradle `processResources` / `sourceSets.main.resources` | resource roots | `exclude` patterns silently drop files |
| JPMS `module-info.java` (`opens`, `provides`, `uses`) | module boundaries and services | changes what is accessible at all |
| `META-INF/services/<iface>` | `ServiceLoader` providers | a missing file removes the implementation silently |
| `java.library.path` / `System.loadLibrary` / JNI / JNA | native libraries | the `.so`/`.dll`/`.dylib` must be findable at runtime |
| `jextract`-generated bindings | native interop | generated sources are build artifacts — never committed |
| `application.properties` / `application.yml` | configuration | resource-root file; env vars and system properties override it |

A contract row with no mechanism here is a census defect — the row must name which of the above
carries it.

## 3. Built-unit list

The set that must match between baseline and upgrade: **the compiled-class set of the built
artifact**.

| Build shape | List |
|---|---|
| thin jar | the class entries of `target/<artifact>.jar` |
| fat / uber jar | the class entries of the shaded jar, including relocated (`shaded.`) packages |
| JPMS | `jar --describe-module` output, plus the module's `requires` list |
| Gradle | the class entries of `build/libs/<artifact>.jar` |

Compare against the baseline built-unit set from slot 1. A missing class is E1; an extra one is
a footprint question, not automatically a failure.

Relocation counts separately: a fat jar that shades `org.slf4j` into `shaded.org.slf4j` keeps
behaviour but changes every class name — record it as a disposition, never as a silent rename.

## 4. Shipped output form

| Shape | Artifact | Side-car rule |
|---|---|---|
| thin jar | `target/<artifact>.jar` | needs a JRE on the host |
| fat jar | one shaded jar | self-contained except the JRE |
| `jpackage` app-image | `artifacts/<app>/` with a bundled runtime | fully self-contained; side-cars land beside the launcher |
| `jpackage` installer | `.deb` / `.msi` / `.pkg` | changes where side-cars may live — re-check slot 5 |

Record which shape the project uses; `jpackage` app-image vs installer changes both the
side-car rules and the smoke-launch command.

## 5. Side-car inputs

Inputs that travel beside the program rather than inside it:

- native libraries (`.so` / `.dll` / `.dylib`) loaded via JNI, JNA or `System.loadLibrary` — must
  be on `java.library.path` or in the app-image's `lib/`
- side-car jars in `lib/` (`-cp lib/*`), or a `Class-Path` manifest entry
- resource bundles, `*.properties`, locale JSON files
- data trees the app reads at startup (CSV, SQLite, H2 files)
- fonts and images loaded from the classpath **or** from disk by path — the latter is a side-car

## 6. Build and ship commands

| Purpose | Command |
|---|---|
| Build (Maven) | `./mvnw -B clean package` |
| Build (Gradle) | `./gradlew clean assemble` |
| Jar (JPMS) | `jar --create --file target/<artifact>.jar --main-class <main>` |
| Package (app-image) | `jpackage --type app-image --input target/<artifact>.jar --dest artifacts/` |
| Class list | the `.class` entries of the built jar |
| Module list | `jar --describe-module --file target/<artifact>.jar` |
| Diff vs baseline | `git diff --name-only <base>..<branch>` and `git diff --numstat` |

The build command is a **declared** command: it goes in the plan verbatim, and the footprint
audit (P5a) runs exactly that command. Do not substitute a different packaging mode at audit
time.

## 7. Smoke launch

| Shape | Launch |
|---|---|
| thin / fat jar | `java -jar target/<artifact>.jar` |
| app-image | `artifacts/<app>/bin/<launcher>` |
| headless CI probe | `java -Djava.awt.headless=true -jar target/<artifact>.jar` |

For Swing/AWT apps, a headless probe proves class loading and startup logic but **not** the UI
path. Record that limit explicitly: a headless smoke that passes is evidence about startup, not
about rendering. Where the UI must be exercised, that is a `walkthrough` row for the human.

Evidence to record: the process starts, the main window title appears (or the headless
equivalent logs its banner), no first-run crash, and the process exits or idles as expected.

## 8. Upgrade hazards

What to check for when a Java app moves to a newer JDK — each is a parity risk the census must
cover:

| Hazard | What breaks | Check |
|---|---|---|
| JPMS vs classpath | `module-info.java` presence changes access rules; named modules cannot read the unnamed module | record whether the app is modular, and re-check every reflective read |
| `sun.misc.*` / `sun.*` internals | removed or unsupported in newer JDKs | grep the source, record each hit as `dead-in-source` or port |
| `SecurityManager` | deprecated, removed in recent JDKs | inventory every use |
| `finalization` / `Thread.stop` / `Thread.suspend` | removed | grep and record |
| `javax.*` → `jakarta.*` | the namespace migration for Spring/Hibernate/etc. | inventory every `javax.` import that must move |
| Restricted native access (JEP 472) | `Unsafe` and native-library loading warn or fail on newer JDKs | test the native path explicitly, not just startup |
| `Nashorn` | removed | record each script engine use |
| `Applet` / `AppletViewer` | removed | record as `dead-in-source` if present |
| AWT/Swing internals | `sun.awt` internals, peer changes, HiDPI scaling | record the scaling assumptions; probe the UI path |
| Dependency convergence | JPMS does not pull transitive deps automatically | resolve the dependency tree and diff it |
| Maven/Gradle plugin alignment | old plugins fail on a new JDK | record the plugin versions and the JDK they were validated against |
| `URLClassLoader` | removed or restricted | record each custom classloader use |
| `lib/` naming | a `lib/` folder next to the jar collides with `java.library.path` conventions | confirm the layout before shipping |
| JDK floor | the app may need a specific minimum JDK | record the floor, and whether the target JDK still supports it |

Record each hazard you check in the census with its disposition — a hazard not checked is a
parity assumption, and parity assumptions are what this harness exists to eliminate.
