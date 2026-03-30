local M = {}

local function report_error(notify_error, message)
  if notify_error then
    notify_error(message)
  end
end

local function dir_exists(dir)
  if vim.fn.isdirectory(dir) == 1 then
    return true
  end

  local normalized = M.normalize_dir(dir)
  if vim.fn.isdirectory(normalized) == 1 then
    return true
  end

  return vim.fn.isdirectory(normalized:gsub("/", "\\")) == 1
end

function M.normalize_dir(path)
  return (path or ""):gsub("\\", "/"):gsub("/+$", "")
end

function M.join_path(base, name)
  return string.format("%s/%s", M.normalize_dir(base), name)
end

function M.ensure_parent_dir(file_path)
  local dir = M.normalize_dir(vim.fn.fnamemodify(file_path, ":h"))
  if dir == "" or dir_exists(dir) then
    return true
  end

  local ok, result = pcall(vim.fn.mkdir, dir, "p")
  if ok then
    return result == 1 or dir_exists(dir)
  end

  return dir_exists(dir)
end

function M.write_file(content, file_path, notify_error)
  if not M.ensure_parent_dir(file_path) then
    report_error(notify_error, string.format("Can't create directory for: %s", file_path))
    return false
  end

  local file, open_err = io.open(file_path, "w")
  if not file then
    report_error(notify_error, string.format("Can't write file: %s (%s)", file_path, open_err or "unknown error"))
    return false
  end

  file:write(content)
  file:close()
  return true
end

function M.write_json_file(obj, file_path, notify_error)
  local ok, content = pcall(vim.json.encode, obj)
  if not ok then
    report_error(notify_error, string.format("Can't encode json for: %s", file_path))
    return false
  end

  return M.write_file(content, file_path, notify_error)
end

function M.read_json_file(file_path, default_value, notify_error)
  local fallback = default_value
  if fallback == nil then
    fallback = {}
  end

  if vim.fn.filereadable(file_path) ~= 1 then
    return vim.deepcopy(fallback)
  end

  local file, open_err = io.open(file_path, "r")
  if not file then
    report_error(notify_error, string.format("Can't read file: %s (%s)", file_path, open_err or "unknown error"))
    return vim.deepcopy(fallback)
  end

  local content = file:read("*a")
  file:close()

  if content == "" then
    return vim.deepcopy(fallback)
  end

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then
    report_error(notify_error, string.format("Invalid json in: %s", file_path))
    return vim.deepcopy(fallback)
  end

  return decoded
end

return M
