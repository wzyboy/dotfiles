function Linemode:mtime_isoformat()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  else
    time = os.date("%Y-%m-%d %H:%M:%S", time)
  end
  return time
end
