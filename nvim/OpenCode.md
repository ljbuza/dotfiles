# OpenCode Configuration for LazyVim

## Build/Lint/Test Commands
- **Format Lua**: `stylua .` (uses stylua.toml config)
- **Check config**: `nvim --headless -c "checkhealth" -c "qa"`
- **Reload config**: `:source %` or restart nvim

## Code Style Guidelines

### Lua Formatting
- Use 2 spaces for indentation (per stylua.toml)
- Max line width: 120 characters
- Use double quotes for strings
- No trailing commas in tables

### Plugin Structure
- Place plugins in `lua/plugins/` directory
- Each plugin file should return a table/array of plugin specs
- Use lazy loading with `lazy = false` for critical plugins
- Set `priority = 1000` for colorschemes and essential plugins

### Configuration Patterns
- Use `opts = {}` for simple plugin configuration
- Use `config = function()` for complex setup requiring require() calls
- Disable unused features explicitly (e.g., `inlay_hints = { enabled = false }`)
- Comment out unused plugin configurations rather than deleting