# Repository Guidelines

## Project Structure & Module Organization
- `src/einkaufsliste.cr` starts the Crumble server and pulls in resources, policies, models, styles, and Stimulus controllers.
- `src/resources` holds the HTTP resources (e.g., `list_resource.cr`); `src/views` contains the matching UI components and layouts.
- `src/models` defines Orma records backed by SQLite; `src/policies` guards access; `src/stimulus_controllers` provides frontend behavior.
- `assets` hosts static files; `styles` contains shared style helpers; `bin` ships helper binaries; `data.db` is the local dev SQLite database.

## Build, Test, and Development Commands
- Install deps: `shards install`.
- Run dev server (SQLite, auto-migrations): `DATABASE_URL=sqlite3://./data.db ORMA_CONTINUOUS_MIGRATION=1 crystal run --error-trace src/einkaufsliste.cr -- -p 3002`.
- Auto-reload during development: ensure `watchexec` is installed, then `./watch.sh` (watches `src`/`lib` and restarts).
- Optional native build: `crystal build src/einkaufsliste.cr -o bin/einkaufsliste`.
- If you run into file permission errors, you are allowed to create a temporary local cache directory. Make sure to remove it again after you finished using it.

## Coding Style & Naming Conventions
- Follow Crystal defaults: 2-space indentation, snake_case methods/variables, CamelCase classes/modules.
- Be aware that the Crystal compiler automatically converts symbol literals to enum values in method arguments - use that feature.
- Keep resource/policy/model filenames aligned with their class names (e.g., `list_resource.cr`, `list_policy.cr`).
- Run `crystal tool format` before committing; prefer small, focused files mirroring framework directories (resources/views/policies/models).

## Testing Guidelines
- No automated specs are present yet; add Crystal specs under `spec/` with filenames ending `_spec.cr`, then run `crystal spec`.
- For UI/resource changes, smoke-test at `http://localhost:3002`: create a list, add/remove items, and verify share/access flows.
- When adding database changes, ensure `ORMA_CONTINUOUS_MIGRATION=1` covers schema updates; consider committing migration logic if manual steps are required.

## Security & Configuration Tips
- Configure environment via variables (DB URL, `ORMA_CONTINUOUS_MIGRATION`, OTEL settings). Do not commit real API keys or production databases.
- `data.db` is for local development only; replace with a fresh file or separate DSN for staging/production. Back up user data before schema changes outside continuous migration.
