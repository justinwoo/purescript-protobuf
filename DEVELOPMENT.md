# Development Notes

## Generate `packages.json` from `packages.dhall` for `psc-package`

https://psc-package.readthedocs.io/en/latest/usage.html#local-package-sets

```
dhall-to-json –file packages.dhall –output packages.json
```

## Publish

https://pursuit.purescript.org/help/authors

```
pulp docs -- --format html
```
