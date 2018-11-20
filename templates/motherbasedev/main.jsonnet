local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

local compose = import "compose.jsonnet";

local services = inv.parameters.services;


{
  'docker-compose': {
  version: inv.parameters.compose.version,
    ["services"]: compose.add_service(services), 
  },

}
