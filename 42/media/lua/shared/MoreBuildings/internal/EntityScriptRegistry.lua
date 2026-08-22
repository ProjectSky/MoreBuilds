local EntityScriptRegistry = {}

local descriptors = {}

local function componentNames(script)
  local names = {}
  for index = 0, ComponentType.GetList():size() - 1 do
    local componentType = ComponentType.GetList():get(index)
    if script:containsComponent(componentType) then
      names[#names + 1] = tostring(componentType)
    end
  end
  table.sort(names)
  return names
end

local function resolve(scriptName)
  assert(type(scriptName) == 'string' and scriptName ~= '', 'entity script name is required')
  local cached = descriptors[scriptName]
  if cached then
    return cached
  end

  local script = getScriptManager():getGameEntityScript(scriptName)
  assert(script ~= nil, 'missing entity script: ' .. scriptName)

  local spriteConfig = script:getComponentScriptFor(ComponentType.SpriteConfig)
  local objectInfo = spriteConfig and SpriteConfigManager.GetObjectInfo(script:getName()) or nil
  local craftRecipeComponent = script:getComponentScriptFor(ComponentType.CraftRecipe)
  local craftRecipe = craftRecipeComponent and craftRecipeComponent:getCraftRecipe() or nil
  local descriptor = {
    componentNames = componentNames(script),
    craftRecipe = craftRecipe,
    hasCraftRecipe = craftRecipe ~= nil,
    hasSpriteConfig = spriteConfig ~= nil,
    objectInfo = objectInfo,
    script = script,
    scriptName = scriptName,
    spriteConfig = spriteConfig,
  }
  descriptor.isBuildable = descriptor.hasSpriteConfig and descriptor.objectInfo ~= nil and descriptor.hasCraftRecipe
  descriptors[scriptName] = descriptor
  return descriptor
end

function EntityScriptRegistry.get(scriptName)
  return resolve(scriptName)
end

function EntityScriptRegistry.getForDefinition(definition)
  assert(definition.placement.kind == 'morebuilds:entity', 'definition is not an entity: ' .. definition.id)
  return resolve(definition.placement.data.entityScript)
end

function EntityScriptRegistry.requireBuildable(definition)
  local descriptor = EntityScriptRegistry.getForDefinition(definition)
  assert(descriptor.hasSpriteConfig, 'entity script has no SpriteConfig: ' .. definition.id)
  assert(descriptor.objectInfo ~= nil, 'missing SpriteConfig object info: ' .. definition.id)
  assert(descriptor.hasCraftRecipe, 'entity script has no constructible CraftRecipe: ' .. definition.id)
  return descriptor
end

function EntityScriptRegistry.clear()
  descriptors = {}
end

return EntityScriptRegistry
