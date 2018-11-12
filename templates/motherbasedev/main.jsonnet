local kap = import "lib/kapitan.libjsonnet";
local inv = kap.inventory();

local dataplane = import "dataplane.jsonnet";
local hashicorp = import "hashicorp.jsonnet";
local saltenv = import "saltenv.jsonnet";

local services = inv.parameters.compose.services;

{
  [if "dataplane" in services then "dataplane"]: dataplane,
  [if "hashicorp" in services then "hasicorp"]: hashicorp,
  [if "saltenv" in services then "saltenv"]: saltenv,
}
