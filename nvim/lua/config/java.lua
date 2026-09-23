local jdtls = require("jdtls")

-- Find the launcher JAR (wildcard won't work in -jar)
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Make sure it found the jar
if launcher_jar == "" then
  vim.notify("JDTLS launcher jar not found", vim.log.levels.ERROR)
  return
end

-- Use Git, Maven, Gradle, or root of current folder as project root
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
-- Fall back to the file's own directory for loose single-file projects
local root_dir = require("jdtls.setup").find_root(root_markers)
  or vim.fn.expand("%:p:h")

if root_dir == "" then
  vim.notify("JDTLS root directory not found", vim.log.levels.ERROR)
  return
end

-- Set workspace directory for Eclipse (can be anything)
local home = os.getenv("HOME")
local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Final config
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", mason_path .. "/config_linux",
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

jdtls.start_or_attach(config)

