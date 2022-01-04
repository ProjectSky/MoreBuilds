require 'Items/SuburbsDistributions'

ItemAdd = {}

ItemAdd.getSprites = function()
    getTexture('media/textures/Item_woodBarricade.png')
end

Events.OnPreMapLoad.Add(ItemAdd.getSprites)
