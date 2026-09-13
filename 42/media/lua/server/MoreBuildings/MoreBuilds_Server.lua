if isClient() then
  return
end

require('MoreBuildings/Bootstrap')
require('MoreBuildings/DestroyActionCompatibility')
require('MoreBuildings/GeneratorAuthority').install()
require('MoreBuildings/PopularBuildingsAuthority').install()
require('MoreBuildings/RegistryAuthority').install()
require('MoreBuildings/SalvageAuthority').install()
require('MoreBuildings/WaterSourceSystem').install()
