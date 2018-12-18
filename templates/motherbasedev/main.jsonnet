local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

local compose = import "compose.jsonnet";

local services = inv.parameters.services;


{
  'docker-compose': {
  services: compose.add_service(services), 
  version: inv.parameters.compose.version, 
  },

}
