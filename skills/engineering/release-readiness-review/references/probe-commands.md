# Probe Commands

| ecosystem | install/restore | build | test |
| --- | --- | --- | --- |
| dotnet | `dotnet restore` | `dotnet build --no-restore` | `dotnet test --no-build` |
| node | `npm ci` | `npm run build` only if a `build` script exists; else skip ("no build step") | `npm test` only if a `test` script exists; else `npx jest --passWithNoTests`/`npx vitest run` if a framework is detectable; else skip |
| python | `pip install -e .` in a venv (or `python -m build`) | skip unless a build backend requires it | `python -m pytest` if `pytest`/tests dir present; else skip |
| rust | `cargo fetch` | `cargo build` | `cargo test` |
| go | `go mod download` | `go build ./...` | `go test ./...` |
| ruby | `bundle install` | `gem build *.gemspec` | `bundle exec rspec` / `rake test` |
| dart | `dart pub get` | `dart analyze` + `dart compile exe .` if applicable | `dart test` |
| container | — | `docker build .` (requires docker) | n/a |
| mixed | use the primary ecosystem's column (resolved via Step 1 user assertion) | same | same |

Execution: run install → build → test sequentially, 300s timeout each. On build failure only, one clean rebuild retry. Do not retry tests. Optional app smoke test only if non-interactive, side-effect-free, bounded. If the CLI is missing, record `infeasible` and stop — never fabricate a result.
