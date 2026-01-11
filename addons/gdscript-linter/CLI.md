# GDScript Linter - Command Line Interface

Run GDScript code analysis from the terminal using Godot's headless mode.

## Quick Start

```bash
# Analyze current project
godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd

# Analyze specific directories
godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd -- src/ scripts/

# Output as JSON
godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd -- --json
```

## Usage

```
godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd -- [options] [paths...]
```

**Note:** The `--` separator is required before any linter options to distinguish them from Godot's own arguments.

## Arguments

| Argument | Description |
|----------|-------------|
| `[paths...]` | Files or directories to analyze (default: `res://`) |

## Options

| Option | Description |
|--------|-------------|
| `--config <path>` | Path to config file (default: `gdlint.json`) |
| `--format <type>` | Output format: `console`, `json`, `clickable`, `html`, `github` |
| `--severity <level>` | Minimum severity to report: `info`, `warning`, `critical` |
| `--check <checks>` | Comma-separated list of checks to run |
| `--json` | Shorthand for `--format json` |
| `--clickable` | Shorthand for `--format clickable` (Godot Output panel format) |
| `--html` | Shorthand for `--format html` |
| `--github` | Shorthand for `--format github` (GitHub Actions annotations) |
| `--output, -o <file>` | Output file path (for `--html`) |
| `--no-ignore` | Bypass all `gdlint:ignore` directives |
| `--help, -h` | Show help message |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | No issues found |
| 1 | Warnings found (no critical issues) |
| 2 | Critical issues found |

## Configuration

### Auto-Sync from Editor

When you change settings in the GDScript Linter dock in the Godot editor, they automatically sync to `gdlint.json` in your project root. The CLI reads this file by default, ensuring editor and CLI use the same settings.

### Config File Format

The linter uses `gdlint.json` in your project root.

Example `gdlint.json`:

```json
{
    "limits": {
        "file_lines_soft": 200,
        "file_lines_hard": 300,
        "function_lines": 30,
        "function_lines_critical": 60,
        "max_parameters": 4,
        "max_nesting": 3,
        "cyclomatic_warning": 10,
        "cyclomatic_critical": 15
    },
    "checks": {
        "file_length": true,
        "function_length": true,
        "parameters": true,
        "nesting": true,
        "todo_comments": true,
        "long_lines": true,
        "print_statements": true,
        "empty_functions": true,
        "magic_numbers": true,
        "commented_code": true,
        "missing_types": true,
        "cyclomatic_complexity": true,
        "god_class": true,
        "naming_conventions": true,
        "unused_variables": true,
        "unused_parameters": true,
        "missing_return_type": true
    },
    "scanning": {
        "respect_gdignore": true,
        "scan_addons": false
    },
    "exclude": {
        "paths": ["addons/", ".godot/", "tests/mocks/"]
    }
}
```

### Custom Configs

Use the "Export Config..." button in the editor to save custom configs (e.g., `gdlint-strict.json` for CI, `gdlint-lenient.json` for development).

```bash
# Use a strict config for CI
godot --headless --script ... -- --config gdlint-strict.json
```

## Output Formats

### Console (default)

Human-readable report with summary, top files, and categorized issues.

### JSON

Machine-parseable output for integration with other tools:

```bash
godot --headless --script ... -- --json > report.json
```

### Clickable

Godot Output panel format with clickable file:line links:

```
res://scripts/player.gd:42: [warning] Function 'update_physics' exceeds 30 lines (45)
```

### GitHub Actions

Annotations that appear directly in GitHub PR diffs:

```bash
godot --headless --script ... -- --github
```

Output format:
```
::error file=scripts/player.gd,line=42::[high-complexity] Function has complexity 25 (max 15)
::warning file=scripts/player.gd,line=100::[long-function] Function exceeds 30 lines (45)
```

### HTML

Self-contained HTML report with interactive filtering:

```bash
godot --headless --script ... -- --html -o report.html
```

## CI/CD Integration

### GitHub Actions

```yaml
name: GDScript Lint

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Godot
        uses: chickensoft-games/setup-godot@v1
        with:
          version: 4.2.1

      - name: Run GDScript Linter
        run: |
          godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd -- --format github
```

### GitLab CI

```yaml
lint:
  image: barichello/godot-ci:4.2.1
  script:
    - godot --headless --script res://addons/gdscript-linter/analyzer/analyze-cli.gd -- --format json > lint-report.json
  artifacts:
    reports:
      codequality: lint-report.json
```

## Examples

### Analyze Multiple Directories

```bash
godot --headless --script ... -- src/ scripts/ autoload/
```

### Show Only Critical Issues

```bash
godot --headless --script ... -- --severity critical
```

### Run Specific Checks

```bash
# Only check for complexity and function length
godot --headless --script ... -- --check high-complexity,long-function
```

### Combine Options

```bash
# Strict CI check: critical issues only, specific checks, GitHub annotations
godot --headless --script ... -- \
    --config gdlint-ci.json \
    --severity critical \
    --check high-complexity,long-function,god-class \
    --format github \
    src/
```

## Available Check IDs

For use with `--check`:

| Check ID | Description |
|----------|-------------|
| `file-length` | Files exceeding line limits |
| `long-function` | Functions exceeding line limits |
| `long-line` | Lines exceeding max length |
| `todo-comment` | TODO, FIXME, HACK comments |
| `print-statement` | Debug print statements |
| `empty-function` | Functions with no implementation |
| `magic-number` | Hardcoded numeric values |
| `commented-code` | Commented-out code blocks |
| `missing-type-hint` | Variables without type hints |
| `missing-return-type` | Functions without return type |
| `too-many-params` | Functions with many parameters |
| `deep-nesting` | Excessive nesting depth |
| `high-complexity` | High cyclomatic complexity |
| `god-class` | Classes with too many members |
| `naming-class` | Class naming convention |
| `naming-function` | Function naming convention |
| `naming-signal` | Signal naming convention |
| `naming-const` | Constant naming convention |
| `naming-enum` | Enum naming convention |
| `unused-variable` | Local variables never used |
| `unused-parameter` | Function parameters never used |

## Performance Notes

- Godot headless mode has ~2-3 second startup overhead
- For interactive use, consider running analysis from within the editor
- For CI/CD, the startup overhead is negligible compared to build times
