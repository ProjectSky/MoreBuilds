if not getMoreBuildInstance then
  require('MoreBuildings/MoreBuilds_Main')
end

local MoreBuild = getMoreBuildInstance()

MoreBuild.onBuildBookShelf = function(ignoreThisArgument, sprite, player, name)
  local bookshelf = ISSimpleFurniture:new(name, sprite.sprite, sprite.northSprite)

  bookshelf.canBeAlwaysPlaced = true
  bookshelf.isContainer = true
  bookshelf.canBeLockedByPadlock = true
  bookshelf.containerType = 'shelves'
  bookshelf:setEastSprite(sprite.eastSprite)
  bookshelf:setSouthSprite(sprite.southSprite)
  bookshelf.player = player
  bookshelf.name = name

  bookshelf.modData['need:Base.Plank'] = 6
  bookshelf.modData['need:Base.Nails'] = 6
  bookshelf.modData['xp:Woodwork'] = 10

  function bookshelf:getHealth()
    --self.javaObject:getContainer():setType("vendingsnack")
    return buildUtil.getWoodHealth(self)
  end

  MoreBuild.equipToolPrimary(bookshelf, player, 'Hammer')

  getCell():setDrag(bookshelf, player)
end

MoreBuild.BookShelfMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  MoreBuild.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 6
    },
    {
      Material = 'Base.Nails',
      Amount = 6
    }
  }

  MoreBuild.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = MoreBuild.skillLevel.complexFurniture
  }

  _sprite = {}
  _sprite.sprite = 'furniture_shelving_01_41'
  _sprite.northSprite = 'furniture_shelving_01_40'
  _sprite.southSprite = 'furniture_shelving_01_42'
  _sprite.eastSprite = 'furniture_shelving_01_43'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildBookShelf, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BookShelf' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)

  _sprite = {}
  _sprite.sprite = 'furniture_shelving_01_45'
  _sprite.northSprite = 'furniture_shelving_01_44'
  _sprite.southSprite = 'furniture_shelving_01_46'
  _sprite.eastSprite = 'furniture_shelving_01_47'

  _name = MoreBuild.getMoveableDisplayName(_sprite.sprite)

  _option = subMenu:addOption(_name, nil, MoreBuild.onBuildBookShelf, _sprite, player, _name)

  _tooltip = MoreBuild.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText 'Tooltip_BookShelf' .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end