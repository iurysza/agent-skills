# Contributing

## Add or change a skill

1. Put the skill in `skills/<kebab-case-name>/SKILL.md`.
2. Keep the frontmatter name identical to the directory.
3. Describe both what the skill does and when to use it.
4. Add `license` and `compatibility` when applicable.
5. Use relative paths for bundled files.
6. Add provenance to `THIRD_PARTY_NOTICES.md` and a local notice when adapting external material.
7. Run:

```bash
./scripts/validate.sh
./scripts/smoke-test.sh
./scripts/compat-test.sh
```

## Publication bar

A skill is publishable only when it is portable, useful outside one machine, free of private state, spec-valid, licensed, and tested through the Vercel CLI discovery path.

Third-party skills should stay upstream unless this repository carries a meaningful, clearly attributed adaptation.
