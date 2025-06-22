# Resource Tagging in portal

In new GIT subscriptions Tagging is done at subscription level and propagates to all resources via azure policy, this is managed by GIT directly

Following Tags are included:

Resource_CostCenter:\
Resource_DataCriticality:\
Resource_Department:\
Resource_Expiration:\
Resource_Owner:

Currently Resource_Expiration will always be set to "never" and Resource_DataCriticality to "public". Neither of them have an impact at the moment.

## Examples

Resource_CostCenter: CC_2002545\
Resource_DataCriticality: public\
Resource_Department: TCI-ED\
Resource_Expiration: never\
Resource_Owner: yves.muheim@axpo.com  

Self service portal modules don't include tagging to avoid duplicities and noise while executing pipelines.