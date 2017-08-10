function clr(hex)
  hex = hex:gsub("#","")
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

print(clr("#9fa8da"))
print(clr("#5c6bc0"))
print(clr("#3f51b5"))
print(clr("#ff7043"))
print(clr("#66bb6a"))
