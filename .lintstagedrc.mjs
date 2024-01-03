export default {
  "**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}": ["prettier --write"],
  "**/{aura,lwc}/**": ["eslint"],
  "**/*.{cls,page,trigger}": (filenames) => `sf scanner run --engine pmd --target ${filenames.join(",")} --json`
};
