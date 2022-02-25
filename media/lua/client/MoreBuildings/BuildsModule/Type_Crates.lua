if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.cratesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 2
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.simpleContainer
  }

  _sprite = {}
  _sprite.sprite = 'location_shop_greenes_01_35'
  _sprite.northSprite = 'location_shop_greenes_01_36'

  _name = getText 'ContextMenu_Half_Crate'
  _icon = 'smallcrate'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText 'Tooltip_Half_Crate' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_shop_greenes_01_37'
  _sprite.northSprite = 'location_shop_greenes_01_38'

  _name = getText 'ContextMenu_Grocery_Box'
  _icon = 'smallbox'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildPassThroughContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText 'Tooltip_Grocery_Box' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'fixtures_bathroom_02_24'
  _sprite.northSprite = 'fixtures_bathroom_02_25'

  _name = getText 'ContextMenu_Outhouse_Box'
  _icon = 'bin'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildPassThroughContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Outhouse_Box' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_entertainment_theatre_01_16'
  _sprite.northSprite = 'location_entertainment_theatre_01_16'

  _name = getText 'ContextMenu_Theatre_Storage'
  _icon = 'counter'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Theatre_Storage' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_farm_accesories_01_8'
  _sprite.northSprite = 'location_farm_accesories_01_9'
  _sprite.eastSprite = 'location_farm_accesories_01_10'
  _sprite.southSprite = 'location_farm_accesories_01_11'

  _name = getText 'ContextMenu_Dog_House'
  _icon = 'officedrawers'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_Dog_House' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_military_generic_01_0'
  _sprite.northSprite = 'location_military_generic_01_2'
  _sprite.eastSprite = 'location_military_generic_01_4'

  _name = getText 'ContextMenu_ArmyGreen_MilitaryCrate'
  _icon = 'militarycrate'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_ArmyGreen_MilitaryCrate' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'location_military_generic_01_8'
  _sprite.northSprite = 'location_military_generic_01_10'
  _sprite.eastSprite = 'location_military_generic_01_12'

  _name = getText 'ContextMenu_ArmyGray_MilitaryCrate'
  _icon = 'militarycrate'

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_ArmyGray_MilitaryCrate' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  local _cardboardBoxesData = MoreBuild.getCardboardBoxesData()

  for _, _currentList in pairs(_cardboardBoxesData) do
    _sprite = {}
    _sprite.sprite = _currentList[1]
    _sprite.northSprite = _currentList[2]

    _name = _currentList[3]

    _option = subMenu:addOption(_name, nil, MoreBuild.onBuildWoodenContainer, _sprite, player, _name, _currentList[4])

    _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = _currentList[5] .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)
  end
end

MoreBuild.getCardboardBoxesData = function()
  cardboardBoxes = {
    {'trashcontainers_01_24', 'trashcontainers_01_25', getText 'ContextMenu_Small_Cardboard_Box', 'smallbox', getText 'Tooltip_Small_Cardboard_Box'},
    {'trashcontainers_01_26', 'trashcontainers_01_27', getText 'ContextMenu_Broken_Cardboard_Box', 'smallbox', getText 'Tooltip_Broken_Cardboard_Box'},
    {'furniture_storage_02_16', 'furniture_storage_02_17', getText 'ContextMenu_Big_Cardboard_Box', 'garage_storage', getText 'Tooltip_Big_Cardboard_Box'},
    {'furniture_storage_02_18', 'furniture_storage_02_19', getText 'ContextMenu_Cardboard_Box', 'garage_storage', getText 'Tooltip_Cardboard_Box'}
  }

  return cardboardBoxes
end

MoreBuild.onBuildPassThroughContainer = function(ignoreThisArgument, sprite, player, name, icon)
  local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

  _container.canPassThrough = true
  _container.renderFloorHelper = true
  _container.canBeAlwaysPlaced = true
  _container.canBeLockedByPadlock = true
  _container.player = player
  _container.name = name

  if sprite.eastSprite then
    _container:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _container:setSouthSprite(sprite.southSprite)
  end

  _container.modData['need:Base.Plank'] = 2
  _container.modData['need:Base.Nails'] = 2
  _container.modData['xp:Woodwork'] = 5

  function _container:getHealth()
    self.javaObject:getContainer():setType(icon)
    return MoreBuild.healthLevel.woodContainer + buildUtil.getWoodHealth(self)
  end

  getCell():setDrag(_container, player)
end