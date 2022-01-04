MoreBuild.WindowsMenuBuilder = function(subMenu, player)
    local _sprite = nil
    local _option = nil
    local _tooltip = nil
    local _name = ''

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_1'
    _sprite.northSprite = 'fixtures_windows_01_1'
    _sprite.corner = 'fixtures_windows_01_1'

    _name = getText 'ContextMenu_Wood_Windows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'Wooden Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_8'
    _sprite.northSprite = 'fixtures_windows_01_8'
    _sprite.corner = 'fixtures_windows_01_8'

    _name = getText 'ContextMenu_White_TiledWindows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'White Tiled Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_16'
    _sprite.northSprite = 'fixtures_windows_01_16'
    _sprite.corner = 'fixtures_windows_01_16'

    _name = getText 'ContextMenu_Tiled_Windows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'Tiled Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_24'
    _sprite.northSprite = 'fixtures_windows_01_24'
    _sprite.corner = 'fixtures_windows_01_24'

    _name = getText 'ContextMenu_White_Windows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'White Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_32'
    _sprite.northSprite = 'fixtures_windows_01_32'
    _sprite.corner = 'fixtures_windows_01_32'

    _name = getText 'ContextMenu_Chrome_Windows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'Chrome Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)

    MoreBuild.neededMaterials = {
        {
            Material = 'Screws',
            Amount = 4,
            Text = getItemText('Screws')
        },
        {
            Material = 'Plank',
            Amount = 4,
            Text = getItemText('Plank')
        }
    }

    MoreBuild.neededTools = {'Screwdriver', 'Saw'}

    _sprite = {}
    _sprite.sprite = 'fixtures_windows_01_56'
    _sprite.northSprite = 'fixtures_windows_01_56'
    _sprite.corner = 'fixtures_windows_01_56'

    _name = getText 'ContextMenu_Slider_Windows'

    _option = subMenu:addOption(_name, worldobjects, MoreBuild.onSurvivalItem, 'Slider Windows')

    _tooltip =
        MoreBuild.canBuildObject(
        MoreBuild.skillLevel.shaokaojiaObject,
        MoreBuild.ElectricityskillLevel.none,
        _option,
        player
    )
    _tooltip:setName(_name)
    _tooltip.description = ' <RGB:106,168,79>' .. getText('Tooltip_WoodWindows') .. _tooltip.description
    _tooltip:setTexture(_sprite.sprite)
end
