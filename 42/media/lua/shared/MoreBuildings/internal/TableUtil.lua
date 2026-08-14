local TableUtil = {}

function TableUtil.copy(value)
  if type(value) ~= 'table' then
    return value
  end

  local copied = {}
  local seen = { [value] = copied }
  local stack = { { source = value, target = copied } }
  while #stack > 0 do
    local frame = stack[#stack]
    stack[#stack] = nil
    for key, nestedValue in pairs(frame.source) do
      local copiedKey = key
      if type(key) == 'table' then
        copiedKey = seen[key]
        if copiedKey == nil then
          copiedKey = {}
          seen[key] = copiedKey
          stack[#stack + 1] = { source = key, target = copiedKey }
        end
      end

      local copiedValue = nestedValue
      if type(nestedValue) == 'table' then
        copiedValue = seen[nestedValue]
        if copiedValue == nil then
          copiedValue = {}
          seen[nestedValue] = copiedValue
          stack[#stack + 1] = { source = nestedValue, target = copiedValue }
        end
      end
      frame.target[copiedKey] = copiedValue
    end
  end
  return copied
end

function TableUtil.stableMergeSort(values, compare)
  local count = #values
  if count < 2 then
    return values
  end

  local buffer = {}
  local width = 1
  while width < count do
    local left = 1
    while left <= count do
      local middle = math.min(left + width, count + 1)
      local right = math.min(left + width * 2, count + 1)
      local firstIndex = left
      local secondIndex = middle
      local targetIndex = left

      while firstIndex < middle and secondIndex < right do
        if compare(values[secondIndex], values[firstIndex]) then
          buffer[targetIndex] = values[secondIndex]
          secondIndex = secondIndex + 1
        else
          buffer[targetIndex] = values[firstIndex]
          firstIndex = firstIndex + 1
        end
        targetIndex = targetIndex + 1
      end
      while firstIndex < middle do
        buffer[targetIndex] = values[firstIndex]
        firstIndex = firstIndex + 1
        targetIndex = targetIndex + 1
      end
      while secondIndex < right do
        buffer[targetIndex] = values[secondIndex]
        secondIndex = secondIndex + 1
        targetIndex = targetIndex + 1
      end

      left = left + width * 2
    end

    for index = 1, count do
      values[index] = buffer[index]
    end
    width = width * 2
  end
  return values
end

return TableUtil
