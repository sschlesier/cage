# Changelog

## v0.3.0 (2026-03-05)

- Use host directory for credentials instead of named volume
- Color Kitty tab green while cage is running

## v0.2.2 (2026-03-04)

- Fix: cache bust the Claude version during image builds to ensure the latest `@anthropic-ai/claude-code` is always installed

## v0.2.1 (2026-03-04)

- Add init process and resource limits to container run

## v0.2.0 (2026-02-28)

- Support stdin piping — cage no longer forces a TTY when stdin is not a terminal, enabling use in pipelines

## v0.1.2 (2026-02-28)

- feat: switch from npm to native Anthropic installer for Claude Code
- feat: smart version check in cage-update — skips rebuild when already up-to-date, prompts with `[y/N]`
- feat: `--force` flag on cage-update to skip version prompt

## v0.1.1 (2026-02-28)

- feat: support Homebrew installation path for Dockerfile
- fix: find Dockerfile via relative path from script, not brew --prefix

## v0.1.0 (2026-02-28)

- Initial release
- feat: include repo name in container names
- feat: ensure skipDangerousModePermissionPrompt is set in entrypoint
- fix: resolve symlinks in cage-update to find Dockerfile correctly
