local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

local compose = import "compose.jsonnet";

local config = inv.parameters.config;

{
  'consul': config['consul'],
  'vault': config['vault'],
}
