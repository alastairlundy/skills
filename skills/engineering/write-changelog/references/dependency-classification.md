---
name: dependency-classification
description: >-
  Source of truth for classifying dependency updates into Runtime, CI, and Testing categories for changelog generation. The inline summary in write-changelog's Step 5 mirrors this file; the two must be updated together.
license: MIT
---

# Dependency Classification

This file is the source of truth for classifying dependency updates into the three categories used by `write-changelog` Step 5. The inline summary in `SKILL.md` (3-row table + tie-breaker line) must mirror this file. **If you change a rule here, update the inline summary in `SKILL.md` in the same edit.**

## Categories

- **Runtime** — packages the application loads at runtime. Production behaviour depends on these.
- **CI** — packages and configurations used to build, test, or release the project, but not loaded at runtime. Includes build tools, linters, formatters, bundlers, and CI workflow files.
- **Testing** — packages used only to verify the application, never loaded at runtime. Includes test frameworks, assertion libraries, and test-only infrastructure.

## Ecosystem mappings

### JavaScript / TypeScript

| File / Location | Field / Signal | Category |
|-----------------|---------------|----------|
| `package.json` | `dependencies` | Runtime |
| `package.json` | `devDependencies` — test framework (`jest`, `vitest`, `mocha`, `chai`, `playwright`, `cypress`, `@testing-library/*`) | Testing |
| `package.json` | `devDependencies` — linter / formatter / bundler (`eslint`, `prettier`, `webpack`, `rollup`, `vite`, `esbuild`, `tsc`, `typescript`) | CI |
| `package.json` | `devDependencies` — anything else | (apply tie-breaker below) |
| `yarn.lock` / `package-lock.json` / `pnpm-lock.yaml` | any change | Runtime |

### Python

| File / Location | Field / Signal | Category |
|-----------------|---------------|----------|
| `requirements.txt` | any change | Runtime |
| `pyproject.toml` | `[project] dependencies` | Runtime |
| `pyproject.toml` | `[project.optional-dependencies]` — test groups (`test`, `tests`, `dev`) | Testing |
| `requirements-dev.txt` | any change | Testing |
| `.github/workflows/*` / CI configs | any change | CI |

### Go

| File / Location | Field / Signal | Category |
|-----------------|---------------|----------|
| `go.mod` | `require` block | Runtime |
| `*_test.go` | test-only package import | Testing |
| `.github/workflows/*` / CI configs | any change | CI |

### Java / Kotlin

| File / Location | Field / Signal | Category |
|-----------------|---------------|----------|
| `pom.xml` | `<dependencies>` without `<scope>test</scope>` | Runtime |
| `pom.xml` | `<dependencies>` with `<scope>test</scope>` | Testing |
| `build.gradle` / `build.gradle.kts` | `dependencies { }` block | Runtime |
| `.github/workflows/*` / CI configs | any change | CI |

## Tie-breaker for ambiguous cases

When a file matches a category table above, use that classification. When the case is ambiguous (e.g., a `devDependency` that is a build tool like `webpack`), **classify by file path, not by dependency name**:

- File path matches `.github/workflows/`, a build script, or is named `*rc*` / `*.config.*` → **CI**
- File path matches `*Tests*` / `*Spec*` / `*Test*` → **Testing**
- Everything else → **Runtime**

## Common edge cases

- **A `chore:`-prefixed commit that touches a dependency file** is classified by the dependency rule above, not by the commit prefix. The Conventional Commit prefix is the primary signal for category; the dependency rule is the secondary signal that overrides the prefix for `chore:`-prefixed dependency commits.
- **Lockfile-only changes** (e.g., `package-lock.json` with no `package.json` change) are still Runtime for JavaScript — the lockfile pins runtime versions.
- **Renamed or moved dependency files** retain their original classification if the new path resolves to the same logical role. If the path moves across the tie-breaker boundaries, apply the tie-breaker to the new path.
