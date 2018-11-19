local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

local compose = import "compose.jsonnet";

local services = inv.parameters.services;
local containers = std.objectHas(inv.parameters.services);


{
  'docker-compose': {
  version: inv.parameters.compose.version,
    [if "services" in services then "services"]: compose.add_service(), 
  },
}