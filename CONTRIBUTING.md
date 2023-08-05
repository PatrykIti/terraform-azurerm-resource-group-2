## Semantic Pull Requests

To generate release and generate changelog, Pull Requests or Commits must have semantic and must follow conventional specs below:
```
PR Name: <type>:<description>
[optional body]
[optional footer(s)]
[required]Label - one of the following:
```
- `feat:` New feature (non-breaking change which adds functionality)
- `fix:` Bug fix (non-breaking change which fixes an issue)
- `docs:` Documentation
- `refactor:`  Code refactor
- `chore:` Changes to the build process or auxiliary tools and libraries such as documentation generation

1. If the label is “BREAKING CHANGE” then MAJOR version is incremented.
2. If the label is "feat" then MINOR version is incremented.
3. If the label is "fix" then the PATCH version is incremented.
4. If the label is doc/refactor/chore, then nothing is incremented and no release is made.
5. Label 'changelog' is reserved for "Automated PRs"

Example commits:
```
feat: added RANDOM string generator for SQL Server passwords
```
```
fix: correcting 'count' logic for SQL Server extended auditing resource block
```
```
feat: added Enable HTTPS Only parameter
BREAKING CHANGE: added FailOver Group resource block
```